import User from './User'
import GeneralData from './GeneralData'
import Catalog from './Catalog'
import Career from './Career';
import Division from './Division';
import LastAttendance from './LastAttendance';
import moment from 'moment'

export default class Teacher {

    static api_path = 'teachers'
    
    id = 0
    image = null
    user_id = null
    user = new User()
    general_data_id = null
    general_data = new GeneralData()
    status = true
    catalog_id = null
    catalog = new Catalog()
    default_career = new Career()
    divison = new Division()
    last_attendance = new LastAttendance()
    careers = []
    availability_teachers = []
    academic_assignments = []
    schedules = []
    hours_approved = []
    teacher_contracts = []

    get attendance_text() {
        moment.locale('es')
        if (this.last_attendance)
            return 'Última toma de asistencia ' + moment(this.last_attendance.date, 'YYYY-MM-DD').fromNow()
        else
            return 'No hay actividad'
    }

    get attendance_color() {
        if (this.last_attendance) {
            let cur_date = moment().format('DD-MM-YYYY')
            let last_date = moment(this.last_attendance.date).format('DD-MM-YYYY')

            if (cur_date == last_date)
                return 'done'
            else
                return 'error'
        }
        else
            return 'empty'
    }

    getTeacherContractByPeriod(period_id) {
        return this.teacher_contracts.find(tc => tc.period_id === period_id)
    }

}
