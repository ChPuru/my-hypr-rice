class MusicService extends Service {
    static {
        Service.register(this, {}, {
            'player': ['string', 'r'],
            'song': ['string', 'r'],
            'artist': ['string', 'r'],
            'cover': ['string', 'r'],
        });
    }

    constructor() {
        super();
        this.#update();
        Utils.interval(2000, this.#update.bind(this));
    }

    #update() {
        const player = Utils.exec("playerctl -l | head -n 1");
        if (!player) {
            this.update_property('player', '');
            return;
        }
        
        this.update_property('player', player);
        this.update_property('song', Utils.exec("playerctl metadata title"));
        this.update_property('artist', Utils.exec("playerctl metadata artist"));
        this.update_property('cover', Utils.exec("playerctl metadata mpris:artUrl"));
    }
}

export default new MusicService();