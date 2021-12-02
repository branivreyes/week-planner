import Subject from './Subject'
import Teacher from './Teacher'
import Group from './Group'

export default class Schedule {
    
    static api_path = 'schedules'
    
    id = 0
    status = true
    subject_id = 0
    subject = new Subject()
    teacher_id = 0
    teacher = new Teacher()
    group_id = 0
    group = new Group()
    days = []
    month_week_days = []
    incidences = []
    attendance_places = []

}
