import { WeekPlannerTab } from '~/ui-classes'

export default
    addTab: ({state, commit}, tab_data) ->
        tab = new WeekPlannerTab(tab_data ? tab_data : {})
        tab_exists = state.tabs.hasOwnProperty tab.name
        if tab_exists and state.selected_tab_name isnt tab.name
            commit 'setSelectedTabName', tab.name
        if !tab_exists
            commit 'addTab', tab
            commit 'setSelectedTabName', tab.name
        return {tab_exists, tab}
    removeTab: ({state, commit, getters, dispatch}, tab_name) ->
        tab_index = getters.tabs.findIndex (tab) -> tab.name is tab_name
        if getters.tabs.length is 1
            if tab_name is 'new-tab'
                return
            dispatch 'addTab'
        else if state.selected_tab_name is tab_name
            next_tab_index = if tab_index is 0 then 1 else tab_index - 1
            commit 'setSelectedTabName', getters.tabs[next_tab_index].name
        commit 'removeTab', tab_name
    getParentItem: ({state, commit, dispatch, getters}, {id, model, params}) ->
        return $nuxt.api$.weekplanner.show id, model, params
        .then ({parent_ui_item, state_data}) =>
            # Set parent item to state state_data
            commit 'addData', state_data
            type = parent_ui_item.constructor.item_class.api_path
            # Tab data
            ui_items = parent_ui_item.createUiItems(state.data)
            return {
                parent_ui_item
                type
                ui_items
            }
    selectUiItem: ({state, commit, getters}, ui_item) =>
        _ui_item = null
        value = false
        if getters.panel_selected_ui_item isnt ui_item
            if getters.panel_selected_ui_item
                commit 'updateUiItemSelectedProperty',
                    ui_item: getters.panel_selected_ui_item
                    value: false
                commit 'setPanelPreviousSelectedUiItem', getters.panel_selected_ui_item 
            _ui_item = ui_item
            value = true
        else
            commit 'setPanelPreviousSelectedUiItem', ui_item
        if ui_item
            commit 'updateUiItemSelectedProperty',
                ui_item: ui_item
                value: value
        commit 'setPanelSelectedUiItem', _ui_item 
        