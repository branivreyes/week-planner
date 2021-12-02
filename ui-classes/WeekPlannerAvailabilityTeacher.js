import WeekPlannerItem from './WeekPlannerItem'
import AvailabilityTeacher from '../classes/AvailabilityTeacher';

export default class WeekPlannerAvailabilityTeacher extends WeekPlannerItem {
    static deserialize_class = AvailabilityTeacher

    component = 'AvailabilityTeacher'

    priority = 1

}