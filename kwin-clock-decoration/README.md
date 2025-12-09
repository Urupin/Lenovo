# KWin Clock Decoration (C++ plugin)

Плагин для Plasma 6 / KWin, добавляющий текст времени рядом с кнопками окна. Написан на API KDecoration3 (Qt6, KF6).

## Зависимости
Минимальный набор (Ubuntu/Plasma 6):
- `build-essential cmake extra-cmake-modules`
- `qt6-base-dev qt6-wayland-dev`
- `libkf6coreaddons-dev libkf6guiaddons-dev libkf6i18n-dev libkf6config-dev`
- `libkdecorations3-dev`

## Сборка и установка в `~/.local`
```bash
cd ~/soft/Lenovo/kwin-clock-decoration
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$HOME/.local
cmake --build build
cmake --install build

# Применить без перезагрузки
qdbus6 org.kde.KWin /KWin reconfigure
```

После установки выберите тему в «Параметры системы → Управление окнами → Оформление окон» — она появится как **Clock Buttons**. Если не видно — перезапустите KWin/сессию.

## Настройка
- Формат времени и цвета заданы в `src/clockdecoration.cpp` и `src/clockbutton.cpp` (константы). Можно отредактировать и пересобрать.
- Толщина рамок и высота заголовка — в `ClockDecoration::borders()` и `m_titleHeight`.

## Примечания
- Плагин рисует собственные кнопки (круг + символ) и строку времени `ddd dd.MM.yyyy HH:mm`. Кнопки работают только для окон, использующих серверные заголовки (CSD приложений не затронуты).
- Если KWin жалуется, что не может найти плагин, убедитесь, что каталог `~/.local/lib/qt6/plugins/org.kde.kdecoration3` содержит `kwin-clock-decoration.so`, и запустите `kbuildsycoca6` от имени пользователя.
