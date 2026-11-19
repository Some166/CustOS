# custOS v0.1 — Foundation

A fresh foundation for custOS on CC: Tweaked.

## Included
- Boot splash and startup entry point
- Small kernel core with service registration and protected event loop
- Local desktop shell with a bottom taskbar, start menu, clock, and basic windows
- Resolution-aware drawing for standard and Advanced Computers
- Safe shutdown/reboot controls
- Installer script designed to download files from the project's GitHub raw URL

## Requirements
- CC: Tweaked computer (standard or Advanced)
- HTTP enabled in the server config
- For the installer: an internet connection and HTTP enabled

## Important
This is an early development build. It is a local desktop foundation, not yet the complete centralised system.
There is no real user authentication, central permissions system, or shared file service in v0.1.
Do not treat client-side UI checks as security controls.

## Install options

### Option A — From the GitHub repository
1. Upload the contents of this package to the root of your `CustOS` repository, preserving folders.
2. Make sure the repository's default branch is `main`.
3. On a CC: Tweaked computer, run:
   ```
   wget https://raw.githubusercontent.com/Some166/CustOS/main/installer/install.lua install.lua
   install
   ```
4. Restart the computer.

### Option B — Manual placement
CC: Tweaked does not natively extract ZIP files. Extract this archive on your PC, then transfer the files into the matching directories on the computer, or upload them to GitHub and use Option A.

## Boot behaviour
The installer places `startup.lua` at the computer root. On boot it runs `boot/boot.lua`, which loads the kernel and desktop.

## Controls
- Click/tap the Start button to open the launcher.
- Select an application to open its window.
- Click a window title bar to bring it forward.
- Use the `×` button to close a window.
- Use the power menu for reboot or shutdown.

Mouse input is supported when the computer has a monitor or suitable input device. On computers without a mouse, keyboard navigation is available through the terminal event loop.

## Project layout
```
boot/          Bootloader
kernel/        Kernel core
desktop/       Desktop shell and window manager
applications/  Built-in starter applications
installer/     Network installer
configuration/ Default settings
startup.lua    Computer startup entry point
```
