import Teacher from "./Teacher";
import Catalog from "./Catalog";
import Career from "./Career";
import Period from '~/classes/Period'

export default class AcademicAssignment {

    static api_path = 'academic_assignments'

    constructor () {
        super()
    }

    id = 0
    teacher_id = null
    career_id = null
    type_id = null
    days = []
    period_id = null
    period = new Period()

    teacher = new Teacher()
    career = new Career()
    type = new Catalog()
}
