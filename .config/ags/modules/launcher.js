const AppItem = app => Widget.Button({
    on_clicked: () => { App.closeWindow('launcher'); app.launch(); },
    child: Widget.Box({
        children: [
            Widget.Icon({ icon: app.icon_name || "", size: 42 }),
            Widget.Label({ label: app.name, xalign: 0, vpack: 'center' }),
        ],
    }),
});

export const launcher = Widget.Window({
    name: 'launcher',
    visible: false,
    keymode: 'exclusive',
    child: Widget.Box({
        class_name: 'launcher-container',
        vertical: true,
        children: [
            Widget.Entry({
                on_change: ({ text }) => {
                    const list = App.query(text || "").map(AppItem);
                    scrolled_list.child.children = list;
                },
            }),
            Widget.Scrollable({
                hscroll: 'never',
                child: Widget.Box({
                    vertical: true,
                    children: App.query("").map(AppItem),
                }),
            }),
        ],
    }),
});