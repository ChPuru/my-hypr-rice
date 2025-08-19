class SystemService extends Service {
    static {
        Service.register(
            this,
            { 'updated': ['jsobject'] },
            { 'stats': ['jsobject', 'r'] },
        );
    }

    #stats = { cpu: 0, ram: 0 };

    get stats() {
        return this.#stats;
    }

    constructor() {
        super();
        Utils.interval(2000, this.#update.bind(this));
    }

    #update() {
        const cpu = Utils.exec("top -bn1 | grep '%Cpu(s)' | awk '{print $2 + $4}'");
        const ram = Utils.exec("free | awk '/Mem:/ {printf \"%.0f\", $3/$2 * 100}'");
        this.#stats = { cpu: Number(cpu), ram: Number(ram) };
        this.emit('updated', this.#stats);
    }
}

export default new SystemService();