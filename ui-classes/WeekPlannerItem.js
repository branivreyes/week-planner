import WeekPlannerParentItem from "./WeekPlannerParentItem";

export default class WeekPlannerItem {
    static deserialize_class = null 
    
    constructor(data){
        Object.assign(this, data)
    }

    item = null
    selected = false
    priority = 0
    component = 'EmptyHour'
    parent_ui_item = new WeekPlannerParentItem()

    comparators = {}

    get key() {
        return this.weekable_type + (this.item ? this.item.id : '')
    }

    get weekable_type() {
        return this.item ? this.item.constructor.api_path : ''
    }
    
    get add_hour() {
        return true
    }

    get total_hours() {
        return this.days.reduce((total, day) => {
            return total + day.hour_schedules.length
        }, 0)
    }

    get keyed_hours() {
        let keyed = {}
        this.days.forEach(day => {
            day.hour_schedules.forEach(hs => {
                keyed['d' + day.day + 'h' + hs.hour_id] = {
                    day: day,
                    hour_schedule: hs
                }
            })
        })
        return keyed
    }

    beforeSaveHour({store}) {
        
    }

    beforeDestroyHour({store, day, hour}) {

    }

    afterDestroyHour({store, day, hour}) {

    }

    afterDeleteHours({store, day, hour}) {

    }
}