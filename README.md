# Fyntric-Framework

## Star Wars Roleplay Holotablet
A drag-and-drop Garry's Mod addon that ships a fully diegetic GAR tablet interface for serious Star Wars roleplay. It blends Lua networking with a custom HTML dashboard to keep troopers coordinated, recorded, and entertained.

### Features
- **Field reports:** write recon/incident logs with tagging and location context.
- **Encrypted messaging:** short-burst channels with sender/receiver metadata.
- **Contact directory:** regiment-aware rolodex with frequencies and notes.
- **Regiment control:** alert states, duties, rosters, and comms channels with color-coded cards.
- **Announcements:** ship-wide broadcasts with priorities and expiry windows.
- **HoloNet feed:** Twitter-style morale/intel posts with handles, hashtags, and like counts.
- **Training sims:** hyperdrive tuning timing game and Holo-Sabacc memory pairs.
- **Persistence:** JSON-backed storage in `data/starwars_tablet_data.json` with admin wipe command.

### Installation
1. Copy the repository contents into `garrysmod/addons/` (the `lua/` folder is ready for drop-in).
2. Start the server; the addon auto-loads via `lua/autorun/starwars_tablet_init.lua`.

### Usage
- Open the tablet in-game with the console command: `swt_tablet`.
- Admins can clear stored data with: `swt_tablet_clear`.

### File Layout
- `lua/autorun/starwars_tablet_init.lua` — boots the addon on client and server.
- `lua/starwars_tablet/shared.lua` — shared constants/net channel names.
- `lua/starwars_tablet/sv_tablet.lua` — persistence and networked actions for reports, comms, regiments, announcements, holofeed, and scores.
- `lua/starwars_tablet/cl_tablet.lua` — spawns the DHTML-driven tablet and bridges UI actions to the server.
- `lua/starwars_tablet/ui/index.html` — full-screen tablet UI with styling, tabs, and minigames.
