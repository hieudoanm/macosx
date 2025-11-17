/*
Copyright © 2025 NAME HERE <EMAIL ADDRESS>
*/
package cmd

import (
	"fmt"

	"github.com/atotto/clipboard"
	"github.com/spf13/cobra"
)

// clipboardCmd represents the clipboard command
var clipboardCmd = &cobra.Command{
	Use:   "clipboard",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		text, err := clipboard.ReadAll()
		if err != nil {
			panic(err)
		}

		fmt.Println("Clipboard:", text)
	},
}

func init() {
	rootCmd.AddCommand(clipboardCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// clipboardCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// clipboardCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
