const OsdValue = (name, setup) => Widget.Box({
    class_name: 'osd',
    children: [
        Widget.Label({
            label: name,
            class_name: 'osd-name',
        }),
        Widget.ProgressBar({
            class_name: 'osd-progress',
            vpack: 'center',
            setup,
        }),
    ],
});

export const osd = Widget.Window({
    name: 'osd',
    anchor: ['bottom'],
    layer: 'overlay',
    child: Widget.Box({
        class_name: 'osd-container',
        // This is where OSD widgets will be added dynamically
    }),
});

// Expose a global function to show the OSD
globalThis.show_osd = ({ name, value }) => {
    const container = osd.child;
    const existing = container.children.find(ch => ch.attribute.name === name);
    if (existing) {
        existing.destroy();
    }

    const widget = OsdValue(name, self => {
        self.value = value / 100;
    });
    widget.attribute = { name };
    container.add(widget);

    Utils.timeout(2000, () => {
        widget.destroy();
    });
};