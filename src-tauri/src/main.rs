mod utils;

fn main() {
    utils::clipboard::start_clipboard_listener(); // start listening

    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![
            utils::wifi::list_wifi_networks,
            utils::wifi::connect_wifi,
            utils::clipboard::get_clipboard_history,
            utils::clipboard::add_clipboard_entry,
            utils::clipboard::clear_clipboard_history
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
