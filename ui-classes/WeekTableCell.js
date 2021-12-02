import WeekTableItem from "./WeekTableItem";

export default class WeekTableCell {
    
    higher_item_index = 0
    items = [
        new WeekTableItem({
            week_planner_priority: 0,
            week_planner_item_component: 'EmptyHour'
        })
    ]

    get higher_item() {
        return this.items.reduce((prev, current) => (prev.priority > current.priority) ? prev : current)
    }
}