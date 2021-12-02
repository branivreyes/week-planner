import WeekPlannerItem from './WeekPlannerItem'
import AcademicAssignment from '../classes/AcademicAssignment'

export default class WeekPlannerAcademicAssignment extends WeekPlannerItem {

    static deserialize_class = AcademicAssignment

    component = 'AcademicAssignment'

    priority = 2
}