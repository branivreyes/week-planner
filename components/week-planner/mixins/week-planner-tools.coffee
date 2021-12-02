import WeekPlannerTools from '../WeekPlannerTools'
import WeekPlannerToolsItem from '../WeekPlannerToolsItem'
import WeekPlannerTab from '~/ui-classes/WeekPlannerTab'
export default
    props:
        parentUiItem: Object
        tab:
            type: Object
            default: -> new WeekPlannerTab()
        isPanel: Boolean
        isWeekTable: Boolean
    components: {
        WeekPlannerTools
        WeekPlannerToolsItem
    }
    provide: ->
        sharedToolsData: @$props