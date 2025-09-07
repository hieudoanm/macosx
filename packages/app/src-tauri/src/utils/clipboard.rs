use serde::{Deserialize, Serialize};
use std::fs;
use std::path::PathBuf;
use chrono::Utc;
use dirs::data_dir;
use copypasta::{ClipboardContext, ClipboardProvider};
use std::thread;
use std::time::Duration;

pub fn start_clipboard_listener() {
    thread::spawn(move || {
        let mut ctx = ClipboardContext::new().unwrap();
        let mut last_clipboard: Option<String> = None;

        loop {
            if let Ok(current) = ctx.get_contents() {
                if Some(current.clone()) != last_clipboard {
                    last_clipboard = Some(current.clone());
                    // Save to history using your existing command
                    let _ = add_clipboard_entry(current);
                }
            }
            thread::sleep(Duration::from_secs(1)); // check every second
        }
    });
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct ClipboardEntry {
    pub content: String,
    pub timestamp: u64,
}

// JSON file path inside app data
fn get_clipboard_file_path() -> Result<PathBuf, String> {
    let mut dir = data_dir().ok_or("Failed to get app data directory")?;
    dir.push("macosx"); // your app name
    fs::create_dir_all(&dir).map_err(|e| e.to_string())?;
    Ok(dir.join("clipboard_history.json"))
}

// Read clipboard history
#[tauri::command]
pub fn get_clipboard_history() -> Result<Vec<ClipboardEntry>, String> {
    let path = get_clipboard_file_path()?;
    if !path.exists() {
        return Ok(Vec::new());
    }
    let data = fs::read_to_string(&path).map_err(|e| e.to_string())?;
    let history: Vec<ClipboardEntry> = serde_json::from_str(&data).map_err(|e| e.to_string())?;
    Ok(history)
}

// Add a new entry
#[tauri::command]
pub fn add_clipboard_entry(content: String) -> Result<String, String> {
    let mut history = get_clipboard_history().unwrap_or_default();
    let entry = ClipboardEntry {
        content,
        timestamp: Utc::now().timestamp_millis() as u64,
    };
    history.push(entry);

    let path = get_clipboard_file_path()?;
    fs::write(&path, serde_json::to_string_pretty(&history).map_err(|e| e.to_string())?)
        .map_err(|e| e.to_string())?;

    Ok("Saved clipboard entry".into())
}

// Clear history
#[tauri::command]
pub fn clear_clipboard_history() -> Result<String, String> {
    let path = get_clipboard_file_path()?;
    if path.exists() {
        fs::remove_file(path).map_err(|e| e.to_string())?;
    }
    Ok("Clipboard history cleared".into())
}
