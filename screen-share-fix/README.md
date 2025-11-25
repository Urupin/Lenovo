# Screen Share Fix (PipeWire + Portals)

If screen sharing (e.g. Google Meet) shows a blank stream, enable PipeWire + wireplumber and restart portals.

## Files
- `enable-pipewire-portal.sh` — enables `pipewire.socket`, `pipewire.service`, `wireplumber.service` and restarts `xdg-desktop-portal` + `xdg-desktop-portal-gnome`.

## Usage
```bash
./enable-pipewire-portal.sh
```
After running, restart the browser or relogin if sharing still fails.
