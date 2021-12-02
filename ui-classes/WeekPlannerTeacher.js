import WeekPlannerParentItem from "./WeekPlannerParentItem";
import WeekableProperties from './WeekableProperties'
import { 
    Teacher,
    Subject,
    Group,
} from "~/classes";
import WeekPlannerScheduleByGroup from "./WeekPlannerScheduleByGroup";
import WeekPlannerAvailabilityTeacher from "./WeekPlannerAvailabilityTeacher";
import WeekPlannerAcademicAssignment from "./WeekPlannerAcademicAssignment";

export default class WeekPlannerTeacher extends WeekPlannerParentItem {

    static weekable_classes = {
        schedules: WeekPlannerScheduleByGroup,
        availability_teachers: WeekPlannerAvailabilityTeacher,
        academic_assignments: WeekPlannerAcademicAssignment,
        subjects: Subject,
        groups: Group,
    }

    static item_class = Teacher
    
    prior_weekable_property = 'schedules'

    header_component = 'TeacherHeader'
    tools_component = 'TeacherTools'

    /**
     * Key must be the same as the property
     */
    weekable_properties = {
        schedules: new WeekableProperties({
            label: 'Classes',
            panel_component: 'SchedulesPanel'
        }),
        availability_teachers: new WeekableProperties({
            label: 'Availabilities',
            panel_component: 'AvailabilitiesPanel',
        }),
        academic_assignments: new WeekableProperties({
            label: 'Academic Assignments',
            panel_component: 'AcademicAssignmentsPanel',
        }),
    }

    get tab_label() {
        return this.item.general_data.short_name_first
    }
}