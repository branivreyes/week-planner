import WeekPlannerItem from '~/ui-classes/WeekPlannerItem'

export default
    tabs: (state) ->
        Object.values state.tabs
    selected_tab: (state) ->
        state.tabs[state.selected_tab_name]
    selected_parent_item_property: (state, getters) ->
        getters.selected_tab.selected_parent_item_property
    selected_parent_ui_item: (state, getters) ->
        getters.selected_tab.parent_ui_item
    selected_parent_item: (state, getters) ->
        getters.selected_parent_ui_item.item
    panel_selected_ui_item: (state, getters) ->
        getters.selected_tab.panel_selected_ui_item
    panel_selected_item: (state, getters) ->
        getters.panel_selected_ui_item?.item
    panel_previous_selected_ui_item: (state, getters) ->
        getters.selected_tab.panel_previous_selected_ui_item