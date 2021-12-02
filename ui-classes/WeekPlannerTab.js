import WeekPlannerParentItem from "~/ui-classes/WeekPlannerParentItem"   
import HourToMove from '~/components/week-planner/dto/HourToMove'

export default class WeekPlannerTab {
    constructor(data) {
        Object.assign(this, data)
    }
    
    name = 'new-tab'
    label = 'Search tab'
    /**
     * Model that has children with days property
     * Example: Group, Teacher
     */
    parent_ui_item = new WeekPlannerParentItem()
    /**
     * Selected parent item property from panel
     */
    selected_parent_item_property = ''
    /**
     * Model that has days property
     * Example: AvailabilityTeacher, Schedule
     */
    panel_selected_ui_item = null
    panel_previous_selected_ui_item = null

    hour_to_move = new HourToMove() 
    /**
     * Parent items where their children with days property
     * will merge alongside the main parent item.
     * Example: Group, Teacher
     */
    comparators = {}
    ui_items = {}

    loading = false

    get events() {
        let self = this
        return {
            get toggle_select() {
                return self.name + '-' + self.panel_selected_ui_item.key + '-toggle-select'
            },
            get hour_clicked() {
                return self.name + '-' + self.panel_selected_ui_item.key
            },
        }
    }
}