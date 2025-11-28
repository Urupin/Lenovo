# KDE Migration Plan

This outlines a safe switch from GNOME to KDE Plasma (keeping apps/configs). We’ll review before running any install script.

## Goals
- Install stable KDE Plasma desktop (kubuntu-desktop meta).
- Keep existing apps/configs (no removal of GNOME).
- Preserve user data and key configs via backups.
- Keep PipeWire/portals functional for screen sharing.
- Provide a rollback path (keep GDM login option and GNOME session).

## Proposed Steps
1) Backup essentials (no changes to packages yet):
   - User configs: `~/.config`, `~/.local/share`, browser profiles (`~/.config/opera`, `~/.mozilla`, `~/.var/app/...`), PulseAudio/PipeWire configs.
   - Create a dated backup directory: `~/kde-backup-$(date +%F)` and copy configs.
2) Update package lists; ensure disk space.
3) Install KDE Plasma + recommended extras:
   - `sudo apt install kubuntu-desktop kde-standard kde-spectacle plasma-discover flatpak-backend (optional)`.
   - Choose display manager: prefer `sddm`; keep `gdm3` installed for rollback. If prompted, select `sddm`.
4) Ensure audio/screen-share stack stays PipeWire:
   - Verify `pipewire`, `pipewire-pulse`, `wireplumber`, `xdg-desktop-portal`, `xdg-desktop-portal-kde`.
5) Keep GNOME sessions available (no removals).
6) Post-install verification checklist:
   - Login screen shows KDE/Plasma session choice; GNOME still present.
   - Audio works (`pactl info` via PipeWire).
   - Screen sharing works (Meet test).
   - Panel/favorites recreated manually (KDE uses its own panel).
7) Rollback option:
   - At login, choose GNOME session (gdm3 still installed) or switch DM back: `sudo dpkg-reconfigure gdm3`.

## Questions/Choices
- Confirm display manager preference: switch to `sddm` or keep `gdm3` as default?
- Optional extras: install KDE apps bundle (`kde-standard`) or minimal (`plasma-desktop`)?

## Next
- I will prepare a script `kde-migration/run.sh` that:
  1) Makes backups to `~/kde-backup-YYYYMMDD`.
  2) Installs KDE packages and portal.
  3) Leaves GNOME intact and PipeWire active.
- You will run it manually after confirming choices.
