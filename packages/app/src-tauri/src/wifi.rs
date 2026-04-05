use serde::{Deserialize, Serialize};
use std::process::Command;

#[derive(Serialize, Deserialize, Debug)]
pub struct WifiNetwork {
    pub ssid: String,
    pub bssid: String,
    pub rssi: i32,
    pub channel: String,
    pub secure: bool,
}

#[tauri::command]
pub fn connect_wifi(ssid: String, password: Option<String>) -> Result<String, String> {
    let wifi_interface = "en0";

    println!("Attempting to connect to SSID: {}", ssid);
    println!("Interface: {}", wifi_interface);
    println!("Password provided: {}", password.is_some());

    let output = if let Some(pw) = &password {
        println!("Running networksetup with password...");
        Command::new("networksetup")
            .args(&["-setairportnetwork", wifi_interface, &ssid, pw])
            .output()
            .map_err(|e| format!("Failed to execute networksetup: {}", e))?
    } else {
        println!("Running networksetup without password...");
        Command::new("networksetup")
            .args(&["-setairportnetwork", wifi_interface, &ssid])
            .output()
            .map_err(|e| format!("Failed to execute networksetup: {}", e))?
    };

    println!("Command exit status: {:?}", output.status);
    println!("stdout: {}", String::from_utf8_lossy(&output.stdout));
    println!("stderr: {}", String::from_utf8_lossy(&output.stderr));

    if !output.status.success() {
        return Err(format!(
            "networksetup failed: {}",
            String::from_utf8_lossy(&output.stderr)
        ));
    }

    println!("Successfully initiated connection to {}", ssid);
    Ok(format!("Connecting to {}", ssid))
}

#[tauri::command]
pub fn list_wifi_networks() -> Result<Vec<WifiNetwork>, String> {
    // Run system_profiler SPAirPortDataType with JSON output
    let output = Command::new("system_profiler")
        .args(&["SPAirPortDataType", "-json"])
        .output()
        .map_err(|e| format!("Failed to execute system_profiler: {}", e))?;

    if !output.status.success() {
        return Err(format!(
            "system_profiler exited with status code: {:?}",
            output.status.code()
        ));
    }

    let stdout = String::from_utf8_lossy(&output.stdout);
    let json: serde_json::Value = serde_json::from_str(&stdout)
        .map_err(|e| format!("Failed to parse JSON: {}", e))?;

    let mut networks = Vec::new();

    if let Some(airport_data) = json.get("SPAirPortDataType").and_then(|v| v.as_array()) {
        for iface_data in airport_data {
            if let Some(interfaces) = iface_data.get("spairport_airport_interfaces").and_then(|v| v.as_array()) {
                for iface in interfaces {
                    if let Some(wifi_list) = iface.get("spairport_airport_other_local_wireless_networks").and_then(|v| v.as_array()) {
                        for n in wifi_list {
                            let ssid = n.get("_name").and_then(|v| v.as_str()).unwrap_or("<Hidden>").to_string();
                            let channel = n.get("spairport_network_channel").and_then(|v| v.as_str()).unwrap_or("").to_string();
                            let rssi = n
                                .get("spairport_signal_noise")
                                .and_then(|v| v.as_str())
                                .unwrap_or("-100 dBm / -100 dBm")
                                .split_whitespace()
                                .next()
                                .unwrap_or("-100")
                                .replace("dBm", "")
                                .parse::<i32>()
                                .unwrap_or(-100);
                            let secure = !n.get("spairport_security_mode").and_then(|v| v.as_str()).unwrap_or("none").contains("none");

                            networks.push(WifiNetwork {
                                ssid,
                                bssid: "".to_string(),
                                channel,
                                rssi,
                                secure,
                            });
                        }
                    }
                }
            }
        }
    }

    Ok(networks)
}
