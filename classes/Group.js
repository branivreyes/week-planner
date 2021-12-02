import Career from './Career'
import Period from './Period'
import CareerArea from './CareerArea'
import StudyPlan from './StudyPlan'
import Teacher from './Teacher'
import Catalog from './Catalog'

export default class Group {

  static api_path = 'groups'
  

  id = 0
  status = true
  grade = null
  group = ''
  capacity = null
  is_english = false

  tutor_id = null
  tutor = new Teacher()

  turn_id = null
  turn = new Catalog()

  study_plan_id = null
  study_plan = new StudyPlan()

  last_group_id = null
  last_group = null

  career_id = null
  career = new Career()

  period_id = null
  period = new Period()

  career_area_id = null
  career_area = new CareerArea()

  schedules = []

  students = []

  get group_label() {
    if (this.grade !== null)
      return this.grade + ' ° ' + this.group
    return ''
  }

  get last_group_label() {
    return this.grade + ' ° ' + this.group + ' - ' + this.period.description
  }

  get status_label() {
    return this.status ? 'Activo' : 'Inactivo'
  }
}

