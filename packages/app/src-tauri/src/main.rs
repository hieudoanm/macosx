mod utils;

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![
            utils::wifi::list_wifi_networks,
            utils::wifi::connect_wifi
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
