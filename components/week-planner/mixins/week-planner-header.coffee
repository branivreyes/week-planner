import WeekPlannerHeader from '../WeekPlannerHeader'
import WeekPlannerHeaderRow from '../WeekPlannerHeaderRow'
import WeekPlannerHeaderCol from '../WeekPlannerHeaderCol'
import WeekPlannerTab from '~/ui-classes/WeekPlannerTab'

export default
    props:
        parentItem:
            type: Object
        uiParentItem:
            type: Object
        tab:
            type: Object
            default: -> new WeekPlannerTab()
        totalHoursCount:
            type: Number
            default: 0
    components: {
        WeekPlannerHeader
        WeekPlannerHeaderRow
        WeekPlannerHeaderCol
    }