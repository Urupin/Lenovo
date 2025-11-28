# Rotation Tools

Скрипты для ручного разворота экрана на Wayland (GNOME/Unity) и KDE.

## Файлы
- `rotate-wayland.py` — поворачивает дисплей через DBus Mutter. Аргументы: `normal|right|inverted|left`.
- `setup-rotation-hotkeys.sh` — создаёт хоткеи `Super+Ctrl+Alt+Left/Right/Up/Down`, которые вызывают `rotate-wayland.py` с нужным аргументом.
- `rotate-kscreen.sh` — поворачивает экран в KDE через `kscreen-doctor` (выход eDP-1). Аргументы: `normal|right|left|inverted`.

## Использование
1. Назначить горячие клавиши (один раз):  
   ```bash
   ./setup-rotation-hotkeys.sh
   ```
2. Поворачивать через хоткеи Super+Ctrl+Alt+стрелка.  
   Можно вручную: `./rotate-wayland.py right` (или `normal|left|inverted`).
3. В KDE используйте `./rotate-kscreen.sh ...` и привяжите хоткеи через System Settings → Shortcuts → Custom Shortcuts (команда `rotate-kscreen.sh left/right/normal/inverted`).
