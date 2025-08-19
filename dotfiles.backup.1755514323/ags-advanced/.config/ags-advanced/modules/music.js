import MusicService from '../services/music.js';

export const MusicWidget = () => Widget.Box({
    class_name: 'music-widget',
    visible: MusicService.bind('player').transform(p => !!p),
    children: [
        Widget.Icon({
            class_name: 'music-cover',
            icon: MusicService.bind('cover'),
            size: 30,
        }),
        Widget.Label({
            class_name: 'music-info',
            label: MusicService.bind('song').transform(s => ` ${s.substring(0, 20)}...`),
        }),
    ],
});