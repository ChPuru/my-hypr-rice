const Workspaces = () => Widget.Box({
    class_name: 'workspaces',
    children: Hyprland.bind('workspaces').transform(ws => {
        return ws.map(({ id, name }) => Widget.Button({
            on_clicked: () => Hyprland.messageAsync(`dispatch workspace ${id}`),
            child: Widget.Label(`${name}`),
            class_name: Hyprland.active.workspace.bind('id')
                .transform(i => `${i === id ? 'focused' : ''}`),
        }));
    }),
});

const Clock = () => Widget.Label({
    class_name: 'clock',
    setup: self => self
        .poll(1000, self => self.label = Utils.exec('date "+%H:%M  %d-%m-%Y"')),
});

const SysTray = () => Widget.Box({
    class_name: 'systray',
    children: SystemTray.bind('items').transform(items => {
        return items.map(item => Widget.Button({
            child: Widget.Icon({ icon: item.bind('icon') }),
            on_primary_click: (_, event) => item.activate(event),
            on_secondary_click: (_, event) => item.openMenu(event),
            tooltip_markup: item.bind('tooltip_markup'),
        }));
    }),
});

const Left = () => Widget.Box({
    spacing: 8,
    children: [
        Workspaces(),
    ],
});

const Center = () => Widget.Box({
    spacing: 8,
    children: [
        Clock(),
    ],
});

const Right = () => Widget.Box({
    hpack: 'end',
    spacing: 8,
    children: [
        SysTray(),
    ],
});

export const bar = Widget.Window({
    name: 'bar',
    anchor: ['top', 'left', 'right'],
    exclusivity: 'exclusive',
    child: Widget.CenterBox({
        start_widget: Left(),
        center_widget: Center(),
        end_widget: Right(),
        class_name: 'bar-container',
    }),
});