const PowerMenu = () => Widget.Box({
    class_name: 'power-menu',
    vertical: true,
    children: [
        Widget.Button({
            on_clicked: () => Utils.exec('systemctl poweroff'),
            child: Widget.Label('⏻ Shutdown'),
        }),
        Widget.Button({
            on_clicked: () => Utils.exec('systemctl reboot'),
            child: Widget.Label(' Reboot'),
        }),
        Widget.Button({
            on_clicked: () => Utils.exec('hyprlock'),
            child: Widget.Label(' Lock'),
        }),
        Widget.Button({
            on_clicked: () => App.toggleWindow('dashboard'),
            child: Widget.Label(' Close'),
        }),
    ],
});

export const dashboard = Widget.Window({
    name: 'dashboard',
    visible: false,
    keymode: 'exclusive',
    anchor: ['top', 'bottom', 'left', 'right'],
    child: Widget.Box({
        class_name: 'dashboard-container',
        child: PowerMenu(),
    }),
});