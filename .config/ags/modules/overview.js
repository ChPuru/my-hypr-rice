// ~/.config/ags/modules/overview.js
const WorkspaceButton = (id) => Widget.Button({
    class_name: `workspace-btn`,
    on_clicked: () => Hyprland.messageAsync(`dispatch workspace ${id}`),
    child: Widget.Box({
        class_name: 'workspace-content',
        vertical: true,
        children: [
            Widget.Label({
                label: `${id}`,
                class_name: 'workspace-id',
            }),
            Widget.Box({
                class_name: 'workspace-preview',
                setup: self => self.hook(Hyprland, () => {
                    const workspace = Hyprland.workspaces.find(w => w.id === id);
                    const isActive = Hyprland.active.workspace.id === id;
                    const hasWindows = workspace?.windows > 0;
                    
                    self.toggleClassName('active', isActive);
                    self.toggleClassName('occupied', hasWindows);
                    self.toggleClassName('empty', !hasWindows);
                }),
            }),
        ],
    }),
});

const WindowPreview = (client) => Widget.Button({
    class_name: 'window-preview',
    on_clicked: () => Hyprland.messageAsync(`dispatch focuswindow address:${client.address}`),
    child: Widget.Box({
        spacing: 8,
        children: [
            Widget.Icon({
                icon: client.class || 'application-x-executable',
                size: 32,
            }),
            Widget.Box({
                vertical: true,
                children: [
                    Widget.Label({
                        label: client.title || client.class || 'Unknown',
                        class_name: 'window-title',
                        truncate: 'end',
                        max_width_chars: 30,
                        xalign: 0,
                    }),
                    Widget.Label({
                        label: client.class || 'Unknown',
                        class_name: 'window-class',
                        truncate: 'end',
                        max_width_chars: 30,
                        xalign: 0,
                    }),
                ],
            }),
        ],
    }),
});

const WorkspaceOverview = () => Widget.Box({
    class_name: 'workspace-overview',
    spacing: 16,
    children: [
        Widget.Box({
            class_name: 'workspace-grid',
            spacing: 8,
            children: Array.from({ length: 10 }, (_, i) => WorkspaceButton(i + 1)),
        }),
        Widget.Scrollable({
            class_name: 'window-list',
            hscroll: 'never',
            child: Widget.Box({
                vertical: true,
                spacing: 4,
                setup: self => self.hook(Hyprland, () => {
                    const clients = Hyprland.clients.filter(c => c.workspace.id >= 0);
                    self.children = clients.map(WindowPreview);
                }),
            }),
        }),
    ],
});

export const overview = Widget.Window({
    name: 'overview',
    class_name: 'overview-window',
    anchor: ['top', 'bottom', 'left', 'right'],
    margins: [40, 40, 40, 40],
    visible: false,
    keymode: 'exclusive',
    child: Widget.Box({
        class_name: 'overview-container',
        child: WorkspaceOverview(),
    }),
});