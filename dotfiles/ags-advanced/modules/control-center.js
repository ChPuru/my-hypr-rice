const ToggleButton = (name, icon, command, prop) => Widget.Button({
    class_name: 'cc-toggle',
    on_clicked: () => Utils.execAsync(command),
    child: Widget.Box({
        children: [
            Widget.Icon(icon),
            Widget.Label(name),
        ],
    }),
    setup: self => self.hook(prop.service, () => {
        self.toggleClassName('active', prop.gobject.value);
    }, 'notify::' + prop.gobject.name),
});

const WifiToggle = ToggleButton(
    'Wi-Fi', 'network-wireless-symbolic',
    'nmcli radio wifi $([ $(nmcli r wifi) = "enabled" ] && echo "off" || echo "on")',
    { service: Network, gobject: { value: Network.wifi, name: 'wifi-enabled' } }
);

const BluetoothToggle = ToggleButton(
    'Bluetooth', 'bluetooth-symbolic',
    'rfkill toggle bluetooth',
    { service: Bluetooth, gobject: { value: Bluetooth.enabled, name: 'enabled' } }
);

const DndToggle = Widget.Button({
    class_name: 'cc-toggle',
    on_clicked: () => Utils.execAsync('swaync-client -t'),
    child: Widget.Box({
        children: [
            Widget.Icon('notifications-disabled-symbolic'),
            Widget.Label('Do Not Disturb'),
        ],
    }),
    setup: self => self.hook(Swaync, (self, dnd) => {
        self.toggleClassName('active', dnd);
    }, 'dnd'),
});

export const control_center = Widget.Window({
    name: 'control-center',
    visible: false,
    anchor: ['right', 'top', 'bottom'],
    child: Widget.Box({
        class_name: 'cc-container',
        vertical: true,
        children: [
            WifiToggle,
            BluetoothToggle,
            DndToggle,
            // Add more toggles here
        ],
    }),
});