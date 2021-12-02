import Schedule from './Schedule'

export default class Day {

    constructor(data) {
      Object.assign(this, data)
    }

    id = 0
    day = null
    weekable_id = null
    weekable_type = ""
    schedule = new Schedule()
    hour_schedules = []

    get hours () {
      let last_hour = this.hour_schedules[this.hour_schedules.length - 1].hour.end_hour
      let start_hour = this.hour_schedules[0].hour.start_hour
      return start_hour.slice(0, 5) + ' - ' + last_hour.slice(0, 5)
    }


    get key() {
      return 'wd' + this.day
    }
}
