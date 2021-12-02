<template>
    <div 
        class="week-planner-workspace-container"
        v-loading="tab.loading"
        element-loading-text="Loading..."
    >
        <div class="wrapper"
            v-show="!tab.loading"
        >
            <div class="panel-container">
                <component
                    :is="panel_component"
                    :items="panel_items"
                    :tab="tab"
                    :total-hours-count="total_hours_count"
                >

                </component>
            </div>
            <div class="work-area">
                <component
                    :is="header_component"
                    :parent-item="selected_parent_item"
                    :ui-parent-item="selected_parent_ui_item"
                    :tab="tab"
                    :total-hours-count="total_hours_count"
                >
                </component>
                <WeekPlannerWeekTable
                    :table-data="table_data"
                    :tab="tab"
                    :total-hours-count="total_hours_count"
                >

                </WeekPlannerWeekTable>
            </div>
        </div>
    </div>
</template>

<script lang='coffee'>
import WeekPlannerPanel from './WeekPlannerPanel'
import WeekPlannerWeekTable from './WeekPlannerWeekTable'
import WeekPlannerItem from '~/ui-classes/WeekPlannerItem'
import WeekPlannerTab from '~/ui-classes/WeekPlannerTab'
# Headers
import DefaultHeader from './headers/DefaultHeader'
import GroupHeader from './headers/GroupHeader'
import TeacherHeader from './headers/TeacherHeader'
# Panels
import DefaultPanel from './panels/DefaultPanel'
import SchedulesPanel from './panels/SchedulesPanel'
import AvailabilitiesPanel from './panels/AvailabilitiesPanel'
import AcademicAssignmentsPanel from './panels/AcademicAssignmentsPanel'

export default
    name: 'week-planner-workspace'
    components: {
        WeekPlannerPanel
        WeekPlannerWeekTable
        # Headers
        DefaultHeader
        GroupHeader
        TeacherHeader
        # Panels
        DefaultPanel
        SchedulesPanel
        AvailabilitiesPanel
        AcademicAssignmentsPanel
    }
    props:
        tab:
            type: Object
            default: -> new WeekPlannerTab()
    computed:
        selected_tab: ->
            @$store.getters['week_planner/selected_tab']
        selected_parent_ui_item: ->
            @tab.parent_ui_item
        selected_parent_item: ->
            @selected_parent_ui_item.item
        header_component: ->
            @selected_parent_ui_item.header_component
        panel_items: ->
            items = []
            property = @selected_parent_item_property
            if property
                keys = @selected_parent_item[property]
                for key of keys
                    items.push @tab.ui_items[property][key]
            return items
        total_hours_count: ->
            data = 0
            @panel_items.forEach ({item}) ->
                for key, value of item.days
                    data += Object.keys(value).length
            return data
        weekable_properties: ->
            @selected_parent_ui_item.weekable_properties
        selected_parent_item_property: ->
            @tab.selected_parent_item_property
        table_data: ->
            table_structure = @createTableStructure()
            for parent_ui_item in @table_data_items
                for key, weekable_property of parent_ui_item.weekable_properties
                    if !weekable_property.render_in_weektable
                        continue
                    for id of parent_ui_item.item[key]
                        ui_item = @tab.ui_items[key][id] 
                        if !ui_item
                            ui_item = @addNewUiItem {key, id, parent_ui_item}
                        for day_number, day of ui_item.item.days    
                            for hour_id, hour of day
                                table_structure[hour.hour.key][day_number][ui_item.key] = ui_item
            return table_structure
        table_data_items: ->
            [@selected_parent_ui_item, Object.values(@tab.comparators)...]
        selected_weekable_property: ->
            @weekable_properties[@selected_parent_item_property]
        panel_component: ->
            @selected_weekable_property?.panel_component || 'DefaultPanel'
    methods:
        createTableStructure: ->
            table_structure = {}
            @$store.state.hours.forEach (hour) =>
                day_cols = {}
                @$store.getters.work_days.forEach (day) =>
                    day_cols[day.key] = {
                        'empty_hour': new WeekPlannerItem()
                    }
                table_structure[hour.key] = day_cols
            return table_structure
        addNewUiItem: ({key, id, parent_ui_item}) ->
            ui_class = parent_ui_item.constructor.weekable_classes[key]
            item = @$store.state.week_planner.data[key][id]
            ui_item = new ui_class({item})
            @$store.commit 'week_planner/set',
                target: @tab.ui_items[key]
                key: id
                value: ui_item
            return ui_item
</script>

<style lang="less">
@import (reference) "../../assets/app.less";

.week-planner-workspace-container {
	width: 100%;
	height: 100%;
    position: relative;
    .wrapper {
        display: flex;
        position: absolute;
        left: 0px;
        right: 0px;
        top: 0px;
        bottom: 0px;
    }
	.panel-container {
		width: 210px;
        height: 100%;
        border-right: 1px solid @background-light;
        overflow-y: auto;
	}
	.work-area {
		flex: 1;
        height: 100%;
        overflow-y: auto;
	}
}
</style>
