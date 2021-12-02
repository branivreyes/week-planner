import WeekPlannerTab from '~/ui-classes/WeekPlannerTab'
import WeekPlannerPanel from '../WeekPlannerPanel'
export default
    props:
        items: Array
        tab:
            type: Object
            default: -> new WeekPlannerTab()
        totalHoursCount:
            type: Number
            default: 0
    provide: ->
        weekPlannerPanelProps: @$props
    components: {
        WeekPlannerPanel
    }
    methods:
        $_addItemToWeekableProperty: ({data_property, ui_item}) ->
            { item } = ui_item
            @$store.commit 'week_planner/addData',
                [data_property]:
                    [item.id]: item
            @$store.commit 'week_planner/set',
                target: @tab.ui_items[data_property]
                key: item.id
                value: ui_item
            @$store.commit 'week_planner/set',
                target: @tab.parent_ui_item.item[data_property]
                key: item.id
                value: true
        $_updateAllPanelItems: (data) ->
            items = @items.map (item) -> item.item
            @$store.commit 'week_planner/updateMultipleItems', {
                items
                data
            }