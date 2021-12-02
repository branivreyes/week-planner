<template>
    <WeekPlannerTabs>
    </WeekPlannerTabs>
</template>

<script lang='coffee'>
import WeekPlannerTabs from './WeekPlannerTabs'
import WeekPlannerGroup from '~/ui-classes/WeekPlannerGroup'
import WeekPlannerTeacher from '~/ui-classes/WeekPlannerTeacher'
export default
    name: 'week-planner'
    props:
        additionalData:
            type: Object
        parentItemId:
            type: Number
        parentItemUiClass:
            type: Function
        solo:
            type: Boolean
            default: false
        initialRequestParams:
            type: Object
    components: {
        WeekPlannerTabs
    }
    provide: ->
        weekPlannerLoadTab: @loadTab
        weekPlannerAdditionalData: @additionalData
        weekPlannerSolo: @solo
    methods:
        reset: () ->
            @$store.commit 'week_planner/resetWeekPlannerData'
            @$nextTick =>
                if @solo
                    @loadSoloTab()
                else
                    @addTab()
        addTab: (tab_data) ->
            return @$store.dispatch 'week_planner/addTab', tab_data
        updateTab: (tab_data) ->
            @$store.commit 'week_planner/updateTab', tab_data
        getParentItem: (id, model, params) ->
            return @$store.dispatch 'week_planner/getParentItem', {id, model, params}
        loadTab: (parent_item_id, parent_item_class, params) ->
            item_category = parent_item_class.item_class.api_path
            tab_name = item_category + parent_item_id
            if @isTabLoaded tab_name
                return @$store.commit 'week_planner/setSelectedTabName', tab_name
            if @isParentItemLoaded tab_name
                item = @$store.state.week_planner.data[item_category][parent_item_id]
                existing_parent_ui_item = new parent_item_class({item})
                return @addTab @getTabDataOfParentUiItem(tab_name, existing_parent_ui_item)
            await @addTab
                name: tab_name
                label: 'Loading...'
                loading: true
            @getParentItem parent_item_id, parent_item_class, params
            .then ({parent_ui_item, type, ui_items}) =>
                @updateTab @getTabDataOfParentUiItem(tab_name, parent_ui_item, ui_items)
        isTabLoaded: (tab_name) ->
            !!@$store.state.week_planner.tabs[tab_name]
        isParentItemLoaded: (key) ->
            @$store.state.week_planner.loaded_parent_items[key]
        getTabDataOfParentUiItem: (tab_name, parent_ui_item, ui_items) ->
            ui_items = ui_items || parent_ui_item.createUiItems(@$store.state.week_planner.data)
            return
                name: tab_name
                label: parent_ui_item.tab_label
                parent_ui_item: parent_ui_item
                ui_items: ui_items
                loading: false
                selected_parent_item_property: parent_ui_item.prior_weekable_property
        loadSoloTab: ->
            @loadTab @parentItemId, @parentItemUiClass, @initialRequestParams
    created: ->
        if @solo
            @reset()
            @loadSoloTab()
</script>

<style lang="less">
@import (reference) "../../assets/app.less";
.week-planner-container {
	display: flex;
	height: 100%;
	flex-direction: column;
}
</style>