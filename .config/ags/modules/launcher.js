const AppItem = app => Widget.Button({
    on_clicked: () => {
        App.closeWindow('launcher');
        app.launch();
    },
    child: Widget.Box({
        children: [
            Widget.Icon({
                icon: app.icon_name || "",
                size: 42,
            }),
            Widget.Label({
                label: app.name,
                xalign: 0,
                vpack: 'center',
            }),
        ],
    }),
});

export const Launcher = () => {
    const list = Widget.Box({
        vertical: true,
        children: Applications.query("").map(AppItem),
    });

    const entry = Widget.Entry({
        on_change: ({ text }) => {
            list.children = Applications.query(text || "").map(AppItem);
        },
    });

    return Widget.Window({
        name: 'launcher',
        popup: true,
        child: Widget.Box({
            class_name: 'launcher-container',
            vertical: true,
            children: [
                entry,
                Widget.Scrollable({
                    hscroll: 'never',
                    child: list,
                }),
            ],
        }),
        setup: self => self.keybind("Escape", () => App.closeWindow('launcher')),
    });
};