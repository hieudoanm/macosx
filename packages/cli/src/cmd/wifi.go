package cmd

import (
	"bufio"
	"fmt"
	"os"
	"os/exec"
	"sort"
	"strconv"
	"strings"

	"github.com/charmbracelet/bubbles/list"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/spf13/cobra"
)

////////////////////////////////////////////////////////////
// WiFi Logic
////////////////////////////////////////////////////////////

type Network struct {
	SSID     string
	RSSI     int
	Security string
}

func findAirportPath() (string, error) {
	// 1️⃣ Try PATH lookup first
	if p, err := exec.LookPath("airport"); err == nil {
		return p, nil
	}

	// 2️⃣ Known default locations
	candidates := []string{
		"/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport",
		"/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport",
	}

	for _, p := range candidates {
		if _, err := os.Stat(p); err == nil {
			return p, nil
		}
	}

	// 3️⃣ Spotlight search fallback
	cmd := exec.Command(
		"mdfind",
		"kMDItemFSName == 'airport' && kMDItemKind == 'Unix Executable'",
	)

	out, err := cmd.Output()
	if err == nil {
		lines := strings.Split(strings.TrimSpace(string(out)), "\n")
		if len(lines) > 0 && lines[0] != "" {
			return lines[0], nil
		}
	}

	return "", fmt.Errorf("airport utility not found")
}

func scanWifi() ([]Network, error) {
	airportPath, err := findAirportPath()
	if err != nil {
		return nil, err
	}

	cmd := exec.Command(airportPath, "-s")

	out, err := cmd.Output()
	if err != nil {
		return nil, err
	}

	lines := strings.Split(string(out), "\n")
	var networks []Network

	for i := 1; i < len(lines); i++ {
		line := strings.TrimSpace(lines[i])
		if line == "" {
			continue
		}

		fields := strings.Fields(line)
		if len(fields) < 3 {
			continue
		}

		rssiIndex := len(fields) - 3
		rssi, err := strconv.Atoi(fields[rssiIndex])
		if err != nil {
			continue
		}

		ssid := strings.Join(fields[:rssiIndex-1], " ")
		security := fields[len(fields)-1]

		networks = append(networks, Network{
			SSID:     ssid,
			RSSI:     rssi,
			Security: security,
		})
	}

	sort.Slice(networks, func(i, j int) bool {
		return networks[i].RSSI > networks[j].RSSI
	})

	return networks, nil
}

func connectWifi(ssid, password string) error {
	cmd := exec.Command(
		"networksetup",
		"-setairportnetwork",
		"en0",
		ssid,
		password,
	)

	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	return cmd.Run()
}

////////////////////////////////////////////////////////////
// Bubble Tea List
////////////////////////////////////////////////////////////

type item Network

func (i item) Title() string {
	return i.SSID
}

func (i item) Description() string {
	lock := "🔓"
	if i.Security != "NONE" {
		lock = "🔒"
	}

	return fmt.Sprintf("%s  RSSI: %d  Security: %s", lock, i.RSSI, i.Security)
}

func (i item) FilterValue() string {
	return i.SSID
}

type model struct {
	list   list.Model
	choice *Network
}

func newModel(networks []Network) model {
	var items []list.Item

	for _, n := range networks {
		items = append(items, item(n))
	}

	l := list.New(items, list.NewDefaultDelegate(), 60, 20)
	l.Title = "📡 Select Wi-Fi Network"

	return model{list: l}
}

func (m model) Init() tea.Cmd { return nil }

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {

	case tea.KeyMsg:
		switch msg.String() {

		case "q", "ctrl+c":
			return m, tea.Quit

		case "enter":
			if i, ok := m.list.SelectedItem().(item); ok {
				n := Network(i)
				m.choice = &n
			}
			return m, tea.Quit
		}
	}

	var cmd tea.Cmd
	m.list, cmd = m.list.Update(msg)
	return m, cmd
}

func (m model) View() string {
	if m.choice != nil {
		return fmt.Sprintf("Selected: %s\n", m.choice.SSID)
	}

	return "\n" + m.list.View()
}

func selectNetwork(networks []Network) (*Network, error) {
	p := tea.NewProgram(newModel(networks))
	m, err := p.Run()
	if err != nil {
		return nil, err
	}

	res := m.(model)
	return res.choice, nil
}

////////////////////////////////////////////////////////////
// Cobra Root (single command)
////////////////////////////////////////////////////////////

var wifiCmd = &cobra.Command{
	Use:   "wifi",
	Short: "Scan and connect to WiFi",
	RunE: func(cmd *cobra.Command, args []string) error {

		fmt.Println("📡 Scanning Wi-Fi networks...")

		networks, err := scanWifi()
		if err != nil {
			return err
		}

		if len(networks) == 0 {
			fmt.Println("No networks found.")
			return nil
		}

		choice, err := selectNetwork(networks)
		if err != nil {
			return err
		}

		if choice == nil {
			fmt.Println("Cancelled.")
			return nil
		}

		// Password prompt
		var password string
		if choice.Security != "NONE" {
			fmt.Print("Password: ")
			reader := bufio.NewReader(os.Stdin)
			pw, _ := reader.ReadString('\n')
			password = strings.TrimSpace(pw)
		}

		fmt.Printf("Connecting to %s...\n", choice.SSID)

		err = connectWifi(choice.SSID, password)
		if err != nil {
			return err
		}

		fmt.Println("✅ Connected!")
		return nil
	},
}

func init() {
	rootCmd.AddCommand(wifiCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// clipboardCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// clipboardCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
