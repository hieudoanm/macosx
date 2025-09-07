# macOSX (macOS Extensions)

**macOSX** is a desktop utility built with [Tauri](https://tauri.app/) that extends macOS functionality. It provides tools for managing your clipboard history and connecting to Wi-Fi networks.

## Table of Contents

- [macOSX (macOS Extensions)](#macosx-macos-extensions)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
    - [Clipboard](#clipboard)
    - [Wi-Fi](#wi-fi)
  - [Installation](#installation)
  - [Usage](#usage)
  - [License](#license)

## Features

### Clipboard

- Automatically tracks your clipboard history.
- Save, view, and clear clipboard entries.
- Stores history in a local JSON file for persistence.

### Wi-Fi

- Scan for nearby Wi-Fi networks.
- View signal strength, channel, and security type.
- Connect to networks directly from the app (supports password-protected networks).

## Installation

Clone the repository:

```bash
git clone https://github.com/hieudoanm/macosx.git
cd macosx
```

Install dependencies:

```bash
pnpm install
```

Build and run:

```bash
pnpm run tauri dev
```

## Usage

- Open the app to view clipboard history or Wi-Fi networks.
- Click on a Wi-Fi network to connect. Enter password if required.
- Clipboard entries are automatically saved and can be cleared from the app.

## License

GPL-3.0 License © [hieudoanm](https://github.com/hieudoanm)
