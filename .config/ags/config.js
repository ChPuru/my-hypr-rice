import { bar } from './modules/bar.js';
import { dashboard } from './modules/dashboard.js';
import { control_center } from './modules/control-center.js';
import { launcher } from './modules/launcher.js'; // NEW

App.config({
    style: './style.css',
    windows: [ bar, dashboard, control_center, launcher ], // NEW
});