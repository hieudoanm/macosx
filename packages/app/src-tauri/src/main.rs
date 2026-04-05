mod wifi;

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![
            wifi::list_wifi_networks,
            wifi::connect_wifi
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
