import WeekPlannerItem from "./WeekPlannerItem";

export default class WeekTableItem extends WeekPlannerItem {
    
    constructor(data) {
        super()
        Object.assign(this, data)
    }
}