import WeekPlannerItem from './WeekPlannerItem'
import Schedule from '../classes/Schedule';

export default class WeekPlannerSchedule extends WeekPlannerItem {
    static deserialize_class = Schedule

    show_by = 'teacher'

    component = 'SchoolClassByTeacher'

    comparators = {
        teacher_id: require('./WeekPlannerTeacher'),
        group_id: require('./WeekPlannerGroup'),
    }

}