export default class Hour {
    id = 0
    start_hour = ""
    end_hour = ""
    turn = ""

    constructor(data) {
        Object.assign(this, data)
    }

    get key() {
        let start = this.start_hour.replace(':', '')
        let end = this.end_hour.replace(':', '')
        return `s${start}e${end}`
    }
}