// ~/.config/ags/modules/music.js
const AlbumArt = () => Widget.Box({
    class_name: 'album-art',
    css: 'background-image: url("/tmp/album-art.jpg");',
    setup: self => self.poll(1000, () => {
        Utils.execAsync(['playerctl', 'metadata', 'mpris:artUrl'])
            .then(url => {
                if (url) {
                    Utils.execAsync(['curl', '-o', '/tmp/album-art.jpg', url])
                        .then(() => {
                            self.css = `background-image: url("/tmp/album-art.jpg");`;
                        });
                }
            })
            .catch(() => {
                self.css = 'background-image: url("/usr/share/pixmaps/audio-x-generic.png");';
            });
    }),
});

const TrackInfo = () => Widget.Box({
    class_name: 'track-info',
    vertical: true,
    spacing: 4,
    children: [
        Widget.Label({
            class_name: 'track-title',
            setup: self => self.poll(1000, () => {
                Utils.execAsync(['playerctl', 'metadata', 'title'])
                    .then(title => self.label = title || 'Unknown Track')
                    .catch(() => self.label = 'No media playing');
            }),
        }),
        Widget.Label({
            class_name: 'track-artist',
            setup: self => self.poll(1000, () => {
                Utils.execAsync(['playerctl', 'metadata', 'artist'])
                    .then(artist => self.label = artist || 'Unknown Artist')
                    .catch(() => self.label = '');
            }),
        }),
        Widget.Label({
            class_name: 'track-album',
            setup: self => self.poll(1000, () => {
                Utils.execAsync(['playerctl', 'metadata', 'album'])
                    .then(album => self.label = album || '')
                    .catch(() => self.label = '');
            }),
        }),
    ],
});

const ProgressBar = () => Widget.Box({
    class_name: 'progress-container',
    children: [
        Widget.Label({
            class_name: 'time-current',
            setup: self => self.poll(1000, () => {
                Utils.execAsync(['playerctl', 'position'])
                    .then(pos => {
                        const seconds = Math.floor(parseFloat(pos));
                        const mins = Math.floor(seconds / 60);
                        const secs = seconds % 60;
                        self.label = `${mins}:${secs.toString().padStart(2, '0')}`;
                    })
                    .catch(() => self.label = '0:00');
            }),
        }),
        Widget.Slider({
            class_name: 'progress-bar',
            hexpand: true,
            draw_value: false,
            setup: self => self.poll(1000, () => {
                Promise.all([
                    Utils.execAsync(['playerctl', 'position']).catch(() => '0'),
                    Utils.execAsync(['playerctl', 'metadata', 'mpris:length']).catch(() => '1'),
                ]).then(([pos, length]) => {
                    const position = parseFloat(pos) || 0;
                    const duration = parseFloat(length) / 1000000 || 1;
                    self.value = position / duration;
                });
            }),
        }),
        Widget.Label({
            class_name: 'time-total',
            setup: self => self.poll(1000, () => {
                Utils.execAsync(['playerctl', 'metadata', 'mpris:length'])
                    .then(length => {
                        const seconds = Math.floor(parseFloat(length) / 1000000);
                        const mins = Math.floor(seconds / 60);
                        const secs = seconds % 60;
                        self.label = `${mins}:${secs.toString().padStart(2, '0')}`;
                    })
                    .catch(() => self.label = '0:00');
            }),
        }),
    ],
});

const Controls = () => Widget.Box({
    class_name: 'media-controls',
    spacing: 16,
    children: [
        Widget.Button({
            class_name: 'control-btn',
            child: Widget.Icon('media-skip-backward-symbolic'),
            on_clicked: () => Utils.exec('playerctl previous'),
        }),
        Widget.Button({
            class_name: 'control-btn play-pause-btn',
            child: Widget.Icon({
                setup: self => self.poll(1000, () => {
                    Utils.execAsync(['playerctl', 'status'])
                        .then(status => {
                            self.icon = status === 'Playing' 
                                ? 'media-playback-pause-symbolic'
                                : 'media-playback-start-symbolic';
                        })
                        .catch(() => self.icon = 'media-playback-start-symbolic');
                }),
            }),
            on_clicked: () => Utils.exec('playerctl play-pause'),
        }),
        Widget.Button({
            class_name: 'control-btn',
            child: Widget.Icon('media-skip-forward-symbolic'),
            on_clicked: () => Utils.exec('playerctl next'),
        }),
    ],
});

export const music = Widget.Window({
    name: 'music',
    class_name: 'music-window',
    anchor: ['top'],
    margins: [10, 10, 0, 10],
    visible: false,
    child: Widget.Box({
        class_name: 'music-container',
        spacing: 16,
        children: [
            AlbumArt(),
            Widget.Box({
                class_name: 'music-content',
                vertical: true,
                spacing: 12,
                children: [
                    TrackInfo(),
                    ProgressBar(),
                    Controls(),
                ],
            }),
        ],
    }),
});