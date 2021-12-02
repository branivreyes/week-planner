import User from "./User";
import Teacher from "./Teacher";
import Period from "./Period";
import Career from "./Career";

export default class AvailabilityTeacher {
    
    static api_path = 'availability_teachers'
    
    id = 0
    creation_date = ""
    status = ""
    teacher_id = null
    teacher = new Teacher()
    period_id = null
    period = new Period()
    auth_id = null
    auth = new User()
    career_id = null
    career = new Career()
    availability_notes = []
    days = []

    get week_planner_add_hour() {
        return this.status === 'P'
    }

    get status_string() {
        if(this.status == 'P')
            return "In process";
        else if(this.status == 'E')
            return "Sent";
        else if(this.status == 'A')
            return "Authorized";
        else
            return "";
    }
}
