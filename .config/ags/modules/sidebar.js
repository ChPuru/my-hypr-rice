// ~/.config/ags/modules/sidebar.js
const Profile = () => Widget.Box({
    class_name: 'profile-container',
    vertical: true,
    children: [
        Widget.Box({
            class_name: 'profile-avatar',
            children: [
                Widget.Icon({
                    icon: 'avatar-default-symbolic',
                    size: 80,
                }),
            ],
        }),
        Widget.Label({
            label: 'Welcome back, Puru!',
            class_name: 'profile-name',
        }),
        Widget.Label({
            label: 'Have a productive day',
            class_name: 'profile-subtitle',
        }),
    ],
});

const QuickToggles = () => Widget.Box({
    class_name: 'quick-toggles',
    vertical: true,
    spacing: 8,
    children: [
        Widget.Box({
            spacing: 8,
            children: [
                Widget.Button({
                    class_name: 'toggle-btn wifi-toggle',
                    child: Widget.Box({
                        children: [
                            Widget.Icon('network-wireless-symbolic'),
                            Widget.Label('WiFi'),
                        ],
                    }),
                    on_clicked: () => Utils.exec('nmcli radio wifi toggle'),
                }),
                Widget.Button({
                    class_name: 'toggle-btn bluetooth-toggle',
                    child: Widget.Box({
                        children: [
                            Widget.Icon('bluetooth-symbolic'),
                            Widget.Label('Bluetooth'),
                        ],
                    }),
                    on_clicked: () => Utils.exec('bluetoothctl power toggle'),
                }),
            ],
        }),
        Widget.Box({
            spacing: 8,
            children: [
                Widget.Button({
                    class_name: 'toggle-btn dnd-toggle',
                    child: Widget.Box({
                        children: [
                            Widget.Icon('notifications-disabled-symbolic'),
                            Widget.Label('DND'),
                        ],
                    }),
                    on_clicked: () => Utils.exec('swaync-client -d'),
                }),
                Widget.Button({
                    class_name: 'toggle-btn dark-toggle',
                    child: Widget.Box({
                        children: [
                            Widget.Icon('weather-clear-night-symbolic'),
                            Widget.Label('Dark'),
                        ],
                    }),
                }),
            ],
        }),
    ],
});

const SystemSliders = () => Widget.Box({
    class_name: 'system-sliders',
    vertical: true,
    spacing: 12,
    children: [
        // Volume Slider
        Widget.Box({
            class_name: 'slider-container',
            children: [
                Widget.Icon('audio-volume-high-symbolic'),
                Widget.Slider({
                    class_name: 'volume-slider',
                    hexpand: true,
                    draw_value: false,
                    on_change: ({ value }) => Audio.speaker.volume = value,
                    setup: self => self.hook(Audio, () => {
                        self.value = Audio.speaker?.volume || 0;
                    }, 'speaker-changed'),
                }),
                Widget.Label({
                    class_name: 'slider-value',
                    setup: self => self.hook(Audio, () => {
                        self.label = `${Math.round((Audio.speaker?.volume || 0) * 100)}%`;
                    }, 'speaker-changed'),
                }),
            ],
        }),
        // Brightness Slider
        Widget.Box({
            class_name: 'slider-container',
            children: [
                Widget.Icon('display-brightness-symbolic'),
                Widget.Slider({
                    class_name: 'brightness-slider',
                    hexpand: true,
                    draw_value: false,
                    on_change: ({ value }) => Utils.execAsync(`brightnessctl s ${value * 100}%`),
                    setup: self => self.poll(1000, self => {
                        const current = Number(Utils.exec('brightnessctl g'));
                        const max = Number(Utils.exec('brightnessctl m'));
                        self.value = current / max;
                    }),
                }),
                Widget.Label({
                    class_name: 'slider-value',
                    setup: self => self.poll(1000, self => {
                        const current = Number(Utils.exec('brightnessctl g'));
                        const max = Number(Utils.exec('brightnessctl m'));
                        self.label = `${Math.round((current / max) * 100)}%`;
                    }),
                }),
            ],
        }),
    ],
});

const SystemStats = () => Widget.Box({
    class_name: 'system-stats',
    vertical: true,
    spacing: 8,
    children: [
        Widget.Label({
            label: 'System Performance',
            class_name: 'stats-title',
        }),
        Widget.Box({
            class_name: 'stat-item',
            children: [
                Widget.Icon('cpu-symbolic'),
                Widget.ProgressBar({
                    class_name: 'cpu-progress',
                    setup: self => self.poll(2000, self => {
                        const cpu = Utils.exec("top -bn1 | grep '%Cpu(s)' | awk '{print $2 + $4}'");
                        self.fraction = parseFloat(cpu) / 100;
                    }),
                }),
                Widget.Label({
                    class_name: 'stat-label',
                    setup: self => self.poll(2000, self => {
                        const cpu = Utils.exec("top -bn1 | grep '%Cpu(s)' | awk '{print $2 + $4}'");
                        self.label = `${Math.round(cpu)}%`;
                    }),
                }),
            ],
        }),
        Widget.Box({
            class_name: 'stat-item',
            children: [
                Widget.Icon('memory-symbolic'),
                Widget.ProgressBar({
                    class_name: 'memory-progress',
                    setup: self => self.poll(2000, self => {
                        const mem = Utils.exec("free | awk '/Mem:/ {printf \"%.0f\", $3/$2 * 100}'");
                        self.fraction = parseFloat(mem) / 100;
                    }),
                }),
                Widget.Label({
                    class_name: 'stat-label',
                    setup: self => self.poll(2000, self => {
                        const mem = Utils.exec("free | awk '/Mem:/ {printf \"%.0f\", $3/$2 * 100}'");
                        self.label = `${mem}%`;
                    }),
                }),
            ],
        }),
    ],
});

const MediaPlayer = () => Widget.Box({
    class_name: 'media-player',
    vertical: true,
    spacing: 8,
    children: [
        Widget.Box({
            class_name: 'media-info',
            children: [
                Widget.Icon({
                    class_name: 'media-icon',
                    icon: 'audio-x-generic-symbolic',
                    size: 48,
                }),
                Widget.Box({
                    vertical: true,
                    children: [
                        Widget.Label({
                            class_name: 'media-title',
                            label: 'No media playing',
                            truncate: 'end',
                            max_width_chars: 25,
                        }),
                        Widget.Label({
                            class_name: 'media-artist',
                            label: '',
                            truncate: 'end',
                            max_width_chars: 25,
                        }),
                    ],
                }),
            ],
        }),
        Widget.Box({
            class_name: 'media-controls',
            spacing: 8,
            children: [
                Widget.Button({
                    class_name: 'media-btn',
                    child: Widget.Icon('media-skip-backward-symbolic'),
                    on_clicked: () => Utils.exec('playerctl previous'),
                }),
                Widget.Button({
                    class_name: 'media-btn play-pause',
                    child: Widget.Icon('media-playback-start-symbolic'),
                    on_clicked: () => Utils.exec('playerctl play-pause'),
                }),
                Widget.Button({
                    class_name: 'media-btn',
                    child: Widget.Icon('media-skip-forward-symbolic'),
                    on_clicked: () => Utils.exec('playerctl next'),
                }),
            ],
        }),
    ],
});

export const sidebar = Widget.Window({
    name: 'sidebar',
    class_name: 'sidebar-window',
    anchor: ['right', 'top', 'bottom'],
    margins: [10, 10, 10, 0],
    visible: false,
    keymode: 'exclusive',
    child: Widget.Box({
        class_name: 'sidebar-container',
        vertical: true,
        spacing: 16,
        children: [
            Profile(),
            QuickToggles(),
            SystemSliders(),
            SystemStats(),
            MediaPlayer(),
        ],
    }),
});