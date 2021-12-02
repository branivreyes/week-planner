import Group from "../classes/Group";
import WeekPlannerParentItem from "./WeekPlannerParentItem";
import WeekableProperties from './WeekableProperties'
import Teacher from "../classes/Teacher";
import Subject from "../classes/Subject";
import WeekPlannerScheduleByTeacher from "./WeekPlannerScheduleByTeacher";

export default class WeekPlannerGroup extends WeekPlannerParentItem {

    static weekable_classes = {
        schedules: WeekPlannerScheduleByTeacher,
        teachers: Teacher,
        subjects: Subject,
    }

    static item_class = Group
    
    prior_weekable_property = 'schedules'

    header_component = 'GroupHeader'
    tools_component = 'GroupTools'
    panel_component = 'GroupPanel'
    /**
     * Key must be the same as the property
     */
    weekable_properties = {
        schedules: new WeekableProperties({
            label: 'Classes',
            panel_component: 'SchedulesPanel',
        })
    }

    get tab_label() {
        return this.item.group_label
    }
}