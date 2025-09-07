import Foundation
import CoreWLAN

// Wi-Fi network model
struct WifiNetwork: Codable {
    let ssid: String
    let bssid: String
    let rssi: Int
    let channel: Int
    let secure: Bool
}

// Create Wi-Fi client
let client = CWWiFiClient.shared()

// Get default interface (like "en0")
guard let interface = client.interface() else {
    print("[]")
    exit(0)
}

do {
    // Scan for all nearby Wi-Fi networks
    let networks = try interface.scanForNetworks(withSSID: nil)

    // Convert networks to our Codable struct
    let results = networks.map { network -> WifiNetwork in
        var secure = false

        // macOS Ventura (13+) introduced `supportedSecurityTypes`
        if network.responds(to: Selector(("supportedSecurityTypes"))) {
            if let securityTypes = network.value(forKey: "supportedSecurityTypes") as? Set<Int> {
                secure = !securityTypes.isEmpty
            }
        }
        // Older macOS versions use `security` property
        else if network.responds(to: Selector(("security"))) {
            if let securityNumber = network.value(forKey: "security") as? Int {
                secure = securityNumber != 0
            }
        }

        // Get channel number safely
        let channelNumber = network.wlanChannel?.channelNumber ?? 0

        // Ensure SSID is human-readable, fallback to "<Hidden>"
        let ssidName = network.ssid?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "<Hidden>"

        return WifiNetwork(
            ssid: ssidName,
            bssid: network.bssid ?? "",
            rssi: network.rssiValue,
            channel: channelNumber,
            secure: secure
        )
    }

    // Encode results to JSON
    let jsonData = try JSONEncoder().encode(results)
    if let jsonString = String(data: jsonData, encoding: .utf8) {
        print(jsonString)
    }

} catch {
    // If scanning fails, return empty JSON array
    print("[]")
}
