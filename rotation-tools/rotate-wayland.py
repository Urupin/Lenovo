#!/usr/bin/env python3
"""
Rotate the primary monitor on GNOME/Unity Wayland via Mutter DBus API.
Usage: rotate-wayland.py [normal|right|inverted|left]
"""
import sys
from gi.repository import Gio, GLib

ORIENT = {
    "normal": 0,
    "right": 1,      # 90 deg clockwise
    "inverted": 2,   # 180 deg
    "left": 3,       # 270 deg (counter-clockwise)
}


def main():
    target = sys.argv[1].lower() if len(sys.argv) > 1 else "right"
    if target not in ORIENT:
        print(f"Unknown orientation '{target}'. Use one of: {', '.join(ORIENT)}")
        sys.exit(1)

    bus = Gio.bus_get_sync(Gio.BusType.SESSION, None)
    proxy = Gio.DBusProxy.new_sync(
        bus,
        Gio.DBusProxyFlags.NONE,
        None,
        "org.gnome.Mutter.DisplayConfig",
        "/org/gnome/Mutter/DisplayConfig",
        "org.gnome.Mutter.DisplayConfig",
        None,
    )

    serial, monitors_data, logical_monitors, _ = proxy.call_sync(
        "GetCurrentState",
        None,
        Gio.DBusCallFlags.NONE,
        -1,
        None,
    ).unpack()

    mode_map = {}
    for ident, modes, _m_props in monitors_data:
        current_mode = None
        for mode_id, _w, _h, _rate, _scale, _scales, props in modes:
            if props.get("is-current"):
                current_mode = mode_id
                break
        if not current_mode and modes:
            current_mode = modes[0][0]
        mode_map[tuple(ident)] = current_mode

    # Mutate transforms, keep everything else intact.
    new_logical = []
    for (x, y, scale, _transform, primary, monitors, _props) in logical_monitors:
        conv_monitors = []
        for monitor_id in monitors:
            conn, vendor, product, serial_num = monitor_id
            mode_id = mode_map.get(tuple(monitor_id))
            if mode_id is None:
                # fallback to any known mode string
                mode_id = ""
            conv_monitors.append((conn, mode_id, {}))
        new_logical.append((x, y, scale, ORIENT[target], primary, conv_monitors))

    payload = GLib.Variant(
        "(uua(iiduba(ssa{sv}))a{sv})",
        (
            serial,
            1,  # method: 1 = temporary apply
            new_logical,
            {},
        ),
    )

    proxy.call_sync(
        "ApplyMonitorsConfig",
        payload,
        Gio.DBusCallFlags.NONE,
        -1,
        None,
    )


if __name__ == "__main__":
    main()
