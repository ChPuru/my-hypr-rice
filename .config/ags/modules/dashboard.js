const SystemStats = () => Widget.Box({
    class_name: 'dashboard-card',
    vertical: true,
    children: [
        Widget.Label({ label: 'System Info', class_name: 'card-title' }),
        Widget.Box({
            vertical: true,
            children: [
                Widget.Label({
                    class_name: 'cpu-label',
                    setup: self => self.poll(2000, self => {
                        const cpu = Utils.exec("top -bn1 | grep '%Cpu(s)' | awk '{print $2 + $4}'");
                        self.label = `CPU: ${Math.round(cpu)}%`;
                    }),
                }),
                Widget.Label({
                    class_name: 'ram-label',
                    setup: self => self.poll(2000, self => {
                        const ram = Utils.exec("free | awk '/Mem:/ {printf \"%.0f\", $3/$2 * 100}'");
                        self.label = `RAM: ${ram}%`;
                    }),
                }),
            ],
        }),
    ],
});

const PowerMenu = () => Widget.Box({
    class_name: 'dashboard-card',
    children: [
        Widget.Button({ on_clicked: () => Utils.exec('systemctl poweroff'), child: Widget.Label('⏻') }),
        Widget.Button({ on_clicked: () => Utils.exec('systemctl reboot'), child: Widget.Label('') }),
        Widget.Button({ on_clicked: () => Utils.exec('hyprlock'), child: Widget.Label('') }),
    ],
});

export const dashboard = Widget.Window({
    name: 'dashboard',
    visible: false,
    keymode: 'exclusive',
    anchor: ['top', 'bottom', 'left', 'right'],
    child: Widget.Box({
        class_name: 'dashboard-container',
        child: Widget.CenterBox({
            class_name: 'dashboard-box',
            vertical: true,
            start_widget: SystemStats(),
            end_widget: PowerMenu(),
        }),
    }),
});