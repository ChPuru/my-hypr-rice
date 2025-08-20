const VolumeSlider = () => Widget.Box({
    class_name: 'slider-box',
    children: [
        Widget.Icon('audio-volume-high-symbolic'),
        Widget.Slider({
            hexpand: true,
            draw_value: false,
            on_change: ({ value }) => Audio.speaker.volume = value,
            setup: self => self.hook(Audio, () => {
                self.value = Audio.speaker?.volume || 0;
            }, 'speaker-changed'),
        }),
    ],
});

const BrightnessSlider = () => Widget.Box({
    class_name: 'slider-box',
    children: [
        Widget.Icon('display-brightness-symbolic'),
        Widget.Slider({
            hexpand: true,
            draw_value: false,
            on_change: ({ value }) => Utils.execAsync(`brightnessctl s ${value * 100}%`),
            setup: self => self.poll(1000, () => {
                // We can't hook brightness, so we poll
                self.value = Number(Utils.exec('brightnessctl g')) / Number(Utils.exec('brightnessctl m'));
            }),
        }),
    ],
});

export const ControlCenter = Widget.Window({
    name: 'control-center',
    anchor: ['right', 'top'],
    popup: true,
    child: Widget.Box({
        class_name: 'cc-container',
        vertical: true,
        children: [
            VolumeSlider(),
            BrightnessSlider(),
        ],
    }),
});