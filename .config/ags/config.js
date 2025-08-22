// ~/.config/ags/config.js
import { bar } from './modules/bar.js';
import { dashboard } from './modules/dashboard.js';
import { launcher } from './modules/launcher.js';
import { sidebar } from './modules/sidebar.js';
import { overview } from './modules/overview.js';
import { notifications } from './modules/notifications.js';
import { calendar } from './modules/calendar.js';
import { music } from './modules/music.js';
import { system } from './modules/system.js';

App.config({
    style: './style.css',
    windows: [
        bar,
        dashboard,
        launcher,
        sidebar,
        overview,
        notifications,
        calendar,
        music,
        system
    ],
    closeWindowDelay: {
        'launcher': 500,
        'dashboard': 500,
    },
});