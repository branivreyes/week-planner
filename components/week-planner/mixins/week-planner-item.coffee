import WeekPlannerItem from '../WeekPlannerItem'
import WeekPlannerItemRow from '../WeekPlannerItemRow'
import EventBus from '../event-bus'
import { 
    mapMutations
    mapActions
    mapState
} from 'vuex'
import {
    HourSchedule
    Day
    Hour
} from '~/classes'
import HourToMove from '~/components/week-planner/dto/HourToMove'
import WeekPlannerTab from '~/ui-classes/WeekPlannerTab'
export default
    provide: -> 
        sharedWeekPlannerItemProps: @$props
        sharedWeekPlannerItemData: @$data
        onDestroyHourClicked: @$_onDestroyHourClicked
        showComparatorData: @$_showComparatorData
        selectItem: @$_selectItem
    props:
        isWeekTable:
            type: Boolean
        isPanel:
            type: Boolean
        uiItem:
            type: Object
        item:
            type: Object
        day:
            type: Object
            default: -> new Day()
        hour:
            type: Object
            default: -> new Hour()
        tab:
            type: Object
            default: -> new WeekPlannerTab()
        collisionItems:
            type: Array
            default: -> []
        isCollisionPopup:
            type: Boolean
            default: false
    components: {
        WeekPlannerItem
        WeekPlannerItemRow
    }
    data: ->
        loading: false
        is_comparator: false
    watch:
        is_parent_comparator: 
            immediate: true
            handler: (value) ->
                @is_comparator = value
    computed: {
        mapState('week_planner', [
            'loaded_parent_items'
        ])...
        day_hour: ->
            day: @day
            hour: @hour
        panel_previous_selected_ui_item: ->
            @tab.panel_previous_selected_ui_item
        selected_parent_item_property: ->
            @tab.selected_parent_item_property
        panel_selected_ui_item: ->
            @tab.panel_selected_ui_item
        panel_selected_item: ->
            @panel_selected_ui_item.item
        selected_tab: ->
            @tab
        selected_parent_ui_item: ->
            @tab.parent_ui_item
        selected_parent_item: ->
            @selected_parent_ui_item.item
        week_planner_data: ->
            @$store.state.week_planner.data
        hour_schedules_ids: ->
            count = []
            for day_number, day of @item.days
                for hour_id, hour_schedule of day
                    count.push hour_schedule.id
            return count
        hours_count: ->
            @hour_schedules_ids.length
        is_same_weekable_property: ->
            @uiItem.weekable_type is @selected_parent_item_property
        is_parent_comparator: ->
            @$_isInComparators @uiItem.parent_ui_item.key
        events: ->
            onHourClicked: @item_global_key
            onToggleSelect: @item_global_key + '-toggle-select'
            moveHour: @item_global_key + '-' + @hour.key
        item_global_key: ->
            @tab.name + '-' + @uiItem.key
        hour_schedule: ->
            @item?.days[@day.key]?[@hour.id] || new HourSchedule()
        is_hour_to_move: ->
            !!@tab.hour_to_move.day.key and !!@tab.hour_to_move.hour_schedule.id
    }
    methods: {
        mapMutations('week_planner', {
            '$_addTabComparatorsAndUiItems': 'addTabComparatorsAndUiItems'
            '$_originalSet': 'set'
            '$_originalDelete': 'delete'
            '$_updateItem': 'updateItem'
            '$_setTabSelectedProperty': 'setTabSelectedProperty'
            '$_updateWeekablePropertiesShowInWeektable': 'updateWeekablePropertiesShowInWeektable'
            '$_updateComparatorsWeekableDataShowInWeektable': 'updateComparatorsWeekableDataShowInWeektable'
            '$_removeTakenBy': 'removeTakenBy'
            '$_setHourToMove': 'setHourToMove'
        })...
        mapActions('week_planner', {
            '$_getParentItem': 'getParentItem'
            '$_selectUiItem': 'selectUiItem'
        })...
        $_addHourToSelectedPanelUiItem: (taken_by) ->
            if @panel_selected_ui_item
                EventBus.$emit @tab.events.hour_clicked, {
                    day: @day
                    hour: @hour
                    component: @
                    ui_item: @panel_selected_ui_item
                    taken_by
                }
        $_onHourClicked: (data) ->
            granted = @$_beforeSaveHour data
            if granted is false
                return
            response_data = await @$_saveHour data
            @$_afterSaveHour response_data
        $_saveHour: ({request_data, cell_data}) ->
            {day, hour, component, ui_item, taken_by} = cell_data
            component.loading = true
            response_data = await @$_storeHour {
                request_data
                day
                hour
                ui_item
                taken_by
            }
            component.loading = false
            if @is_hour_to_move and !response_data.will_delete
                {day, hour_schedule} = @tab.hour_to_move
                @$_deleteHour day.key, hour_schedule.hour_id
                @$_setHourToMove
                    tab: @tab
                    key: new HourToMove()
            return response_data
        $_storeHour: ({request_data, day, hour, ui_item, taken_by}) ->
            response_data = await @api$.weekplanner.store request_data
            if response_data.status isnt 0
                return response_data
            @$_setHour ui_item, day.key, hour.id, response_data.hour_schedule
            if taken_by
                @$_updateItem
                    item: taken_by
                    data:
                        taken_by_id: ui_item.item.id
                        taken_by_type: ui_item.item.constructor.api_path
                        taken_by_hour_schedule_id: response_data.hour_schedule.id
            return response_data
        $_set: (target, key, value) ->
            @$_originalSet { target, key, value }
        $_delete: (target, key) ->
            @$_originalDelete { target, key}
        $_setHour: (ui_item, day_key, hour_id, hour_schedule) ->
            days = ui_item.item.days
            if !days.hasOwnProperty day_key
                @$_set days, day_key, {}
            if !days[day_key].hasOwnProperty hour_id
                @$_set days[day_key], hour_id, hour_schedule
        $_deleteHour: (day_key, hour_id) ->
            @$_delete @item.days[day_key], hour_id
        $_createRequestData: ({day, hour, ui_item, taken_by}) ->
            day: day.number
            weekable_id: ui_item.item.id
            weekable_type: ui_item.item.constructor.api_path
            hour_id: hour.id
            parent_prefix: ui_item.parent_ui_item.item_category
            hour_schedule_id: taken_by?.id
            move_hour: if @is_hour_to_move then @tab.hour_to_move.hour_schedule.id else undefined
        $_onDestroyHourClicked: (all) ->
            request_data = @$_createRequestData
                hour: @hour
                day: @day
                ui_item: @uiItem
            granted = @$_beforeDestroyHour {request_data, all}
            if granted is false
                return
            response_data = await @$_destroyHour {request_data, all}
            @$_afterDestroyHour response_data
        $_destroyHour: ({request_data, all}) ->
            @loading = true
            {to_update} = await @api$.weekplanner.destroy (
                if all then @hour_schedules_ids else @hour_schedule.id), 
                request_data
            if all
                @$_set @item, 'days', {}
            else
                @$_deleteHour @day.key, @hour.id
            if Object.keys(to_update).length 
                @$_removeTakenBy to_update
            @loading = false
        $_beforeSaveHour: ({cell_data, request_data}) ->
        $_afterSaveHour: (response_data) ->
        $_beforeDestroyHour: ({request_data, all})  ->
        $_afterDestroyHour: (response_data) ->
        $_loadComparator: (id, model) ->
            key = model.item_class.api_path + id
            if @$_isInComparators key
                return @$_getComparator key
            if !@$_isParentItemLoaded key
                fun = @$_loadParentItem
            else
                fun = @$_createParentUiItem
            { parent_ui_item, ui_items } = await fun id, model
            @$_addTabComparatorsAndUiItems {
                comparators:
                    [parent_ui_item.key]: parent_ui_item 
                ui_items
            }
            return parent_ui_item
        $_createParentUiItem: (id, model) ->
            item = @$_getDataItem model.item_class.api_path, id
            parent_ui_item = new model({item})
            ui_items = parent_ui_item.createUiItems @week_planner_data
            return { parent_ui_item, ui_items }
        $_loadParentItem: (id, model) ->
            @loading = true
            data = await @$_getParentItem { id, model }
            @loading = false
            return data
        $_isParentItemLoaded: (key) ->
            !!@loaded_parent_items[key]
        $_getDataItem: (category, id) ->
            @week_planner_data[category][id]
        $_isInComparators: (key) ->
            !!@$_getComparator key
        $_getComparator: (key) ->
            @selected_tab.comparators[key]
        $_selectItem: ->
            if @is_comparator
                return
            @$_selectUiItem @uiItem
            if @uiItem.weekable_type isnt @selected_parent_item_property and 
            @uiItem.selected is true
                @$_setTabSelectedProperty { 
                    tab: @tab
                    property: @uiItem.weekable_type
                }
            @$_showComparators()
        $_showComparators: ->
            @$_loadComparators()
            @$_hiddePreviousComparators()
        $_loadComparators: ->
            @$_withComparatorsDo @uiItem, ({id, ui_class}) =>
                if id
                    @$_showComparatorData id, ui_class
        $_showComparatorData: (id, model) ->
            parent_ui_item = await @$_loadComparator id, model
            value = @uiItem is @panel_selected_ui_item
            @$_updateComparatorsWeekableDataShowInWeektable {
                ui_item: parent_ui_item
                value: value
            }
        $_withComparatorsDo: (ui_item, action) ->
            for key, fun of ui_item.comparators
                id = ui_item.item[key]
                ui_class = fun.default
                key = ui_class.item_class.api_path + id
                if key isnt ui_item.parent_ui_item.key
                    action { id, ui_class, key}
        $_hiddePreviousComparators: ->
            previous = @panel_previous_selected_ui_item
            if previous is @uiItem and @panel_selected_ui_item
                return
            if previous
                @$_hiddeWeekableDataOfUiItem previous
        $_hiddeWeekableDataOfUiItem: (ui_item) ->
                @$_withComparatorsDo ui_item, ({key}) =>
                    @$_hiddeComparatorWeekableData key
        $_hiddeComparatorWeekableData: (key) ->
            if @selected_tab.comparators[key]
                @$_updateWeekablePropertiesShowInWeektable {
                    ui_item: @selected_tab.comparators[key]
                    value: false
                }
    }
    created: ->
        if @isPanel
            EventBus.$on @events.onHourClicked, (cell_data) => 
                @$_onHourClicked { 
                    cell_data 
                    request_data: @$_createRequestData { 
                        cell_data...
                        ui_item: @uiItem 
                        taken_by: cell_data.taken_by
                    }
                }
            EventBus.$on @events.onToggleSelect, @$_selectItem
            EventBus.$on @events.moveHour, =>
                console.log 'event'
    beforeDestroy: ->
        if @isPanel
            EventBus.$off Object.values(@events)
    mounted: ->
        if @isWeekTable
            week_planner_item = @$children.find (child) => child.$options.name is 'week-planner-item'
            week_planner_item.$on 'move-hour', =>
                @$_selectItem()
                @$_setHourToMove 
                    key: 
                        day: @day
                        hour_schedule: @hour_schedule
                    tab: @tab