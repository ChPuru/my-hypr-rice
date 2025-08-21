const VolumeSlider = () => Widget.Box({
    class_name: 'slider-box',
    children: [
        Widget.Icon('audio-volume-high-symbolic'),
        Widget.Slider({ hexpand: true, draw_value: false, on_change: ({ value }) => Audio.speaker.volume = value,
            setup: self => self.hook(Audio, () => { self.value = Audio.speaker?.volume || 0; }, 'speaker-changed'),
        }),
    ],
});

const BrightnessSlider = () => Widget.Box({
    class_name: 'slider-box',
    children: [
        Widget.Icon('display-brightness-symbolic'),
        Widget.Slider({ hexpand: true, draw_value: false, on_change: ({ value }) => Utils.execAsync(`brightnessctl s ${value * 100}%`),
            setup: self => self.poll(1000, self => { self.value = Number(Utils.exec('brightnessctl g')) / Number(Utils.exec('brightnessctl m')); }),
        }),
    ],
});

export const control_center = Widget.Window({
    name: 'control-center',
    visible: false,
    anchor: ['right', 'top', 'bottom'],
    child: Widget.Box({
        class_name: 'cc-container',
        vertical: true,
        children: [ VolumeSlider(), BrightnessSlider() ],
    }),
});