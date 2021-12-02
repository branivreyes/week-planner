import Vue from 'vue'
import WeekPlannerTab from '~/ui-classes/WeekPlannerTab'

addNewData = (existing_items, new_items, replace) ->
    for key, item of new_items
        if !existing_items[key]
            Vue.set existing_items, key, item
        else if replace
            new_items[key] = existing_items[key]

mergeData = (target, data, replace) ->
    for key of data
        target_data = target[key]
        node_data = data[key]
        if target_data
            addNewData target_data, node_data, replace
        else
            Vue.set target, key, node_data

export default
    setSelectedTabName: (state, tab_name) ->
        state.selected_tab_name = tab_name
    addTab: (state, tab) ->
        Vue.set state.tabs,
            tab.name,
            tab
    removeTab: (state, tab_name) ->
        Vue.delete state.tabs,
            tab_name
    addData: (state, data) ->
        mergeData state.data, data
    addLoadedParentItem: (state, key) ->
        Vue.set state.loaded_parent_items, key, true
    addComparators: (state, data) ->
        mergeData state.tabs[state.selected_tab_name].comparators, data
    addTabUiItems: (state, {tab_name, ui_items}) ->
        mergeData state.tabs[tab_name].ui_items, ui_items
    addTabComparatorsAndUiItems: (state, {comparators, ui_items}) ->
        mergeData state.tabs[state.selected_tab_name].comparators, comparators
        mergeData state.tabs[state.selected_tab_name].ui_items, ui_items
    updateTab: (state, tab) ->
        _tab = state.tabs[tab.name]
        mergeData _tab.ui_items, tab.ui_items 
        { ui_items, ...data} = tab
        Object.assign _tab, data
    setPanelSelectedUiItem: (state, ui_item) ->
        state.tabs[state.selected_tab_name].panel_selected_ui_item = ui_item
    setPanelPreviousSelectedUiItem: (state, ui_item) ->
        state.tabs[state.selected_tab_name].panel_previous_selected_ui_item = ui_item
    updateItem: (state, {item, data}) ->
        Object.assign item, data
    updateUiItemSelectedProperty: (state, {ui_item, value}) ->
        ui_item.selected = value
    setTabSelectedProperty: (state, { tab, property }) ->
        tab.selected_parent_item_property = property
    updateComparatorsWeekableDataShowInWeektable: (state, {ui_item, value}) ->
        for key, weekable_property of ui_item.weekable_properties
            weekable_property.show_in_weektable = value
    updateWeekablePropertiesAlwaysShow: (state, {ui_item, value}) ->
        for key, weekable_property of ui_item.weekable_properties
            weekable_property.always_show_in_weektable = value
    updateWeekablePropertiesShowInWeektable: (state, {ui_item, value}) ->
        for key, weekable_property of ui_item.weekable_properties
            weekable_property.show_in_weektable = value
    addTeachersToCareer: (state, data) ->
        mergeData state.teachers_by_career, data, true
    removeTakenBy: (state, data) ->
        for property, items of data
            for item in items
                id = item.id
                day = 'wd' + item.day
                hour_id = item.hour_id
                hour_schedule = state.data[property][id].days[day][hour_id]
                Object.assign hour_schedule,
                    taken_by_id: null
                    taken_by_type: null
                    taken_by_hour_schedule_id: null
    set: (state, {target, key, value}) ->
        Vue.set target,
            key,
            value
    delete: (state, {target, key}) ->
        Vue.delete target,
            key
    updateMultipleItems: (state, {items, data}) ->
        items.forEach (item) =>
            Object.assign item, data
    resetWeekPlannerData: (state) ->
        state.tabs = {}
        state.selected_tab_name = ''
        state.loaded_parent_items = {}
        state.data =
            teachers: {}
            groups: {}
            subjects: {}
            schedules: {}
            academic_assignments: {}
            availability_teachers: {}
        state.teachers_by_career = {}
    setHourToMove: (state, {tab, key}) ->
        tab.hour_to_move = key