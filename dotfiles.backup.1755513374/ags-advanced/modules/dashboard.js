const Profile = () => Widget.Box({
    class_name: 'profile',
    vertical: true,
    children: [
        Widget.Icon({
            icon: '##lockscreen_image##',
            size: 100,
            class_name: 'profile-icon',
        }),
        Widget.Label({
            label: '##lockscreen_welcome_text##',
            class_name: 'profile-name',
        }),
    ],
});

const SystemStats = () => Widget.Box({
    class_name: 'system-stats',
    vertical: true,
    children: [
        Widget.Label({ label: 'System Info' }),
        Widget.Box({
            children: [
                Widget.Label('CPU: '),
                Widget.ProgressBar({
                    class_name: 'cpu-progress',
                    vpack: 'center',
                    setup: self => self.hook(globalThis.system, () => {
                        self.value = globalThis.system.stats.cpu / 100;
                    }),
                }),
            ],
        }),
        Widget.Box({
            children: [
                Widget.Label('RAM: '),
                Widget.ProgressBar({
                    class_name: 'ram-progress',
                    vpack: 'center',
                    setup: self => self.hook(globalThis.system, () => {
                        self.value = globalThis.system.stats.ram / 100;
                    }),
                }),
            ],
        }),
    ],
});

const PowerMenu = () => Widget.Box({
    class_name: 'power-menu',
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
            start_widget: Profile(),
            center_widget: SystemStats(),
            end_widget: PowerMenu(),
        }),
    }),
});