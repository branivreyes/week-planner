<template>
    <div 
        class="week-planner-panel"
        v-loading="loading"
        :element-loading-text="loadingText"
    >
        <slot></slot>
        <div class="panel-header">
            <el-select
                :value="selected_parent_item_property"
                @input="setTabSelectedProperty"
                placeholder="Select"
                size="small"
            >
                <el-option
                    v-for="(mode, i) in modes"
                    :key="i"
                    :label="mode.label"
                    :value="mode.value"
                />
            </el-select>
            <slot name="header-tools"></slot>
        </div>
        <div 
            class="panel-items-container"
        >
            <component
                v-for="item in items"
                :key="item.key"
                :is="item.component"
                is-panel
                :ui-item="item"
                :item="item.item"
                :tab="tab"
            >
            </component>
            <div
                class="regular--text body text-xs-center pt-2"
                v-if="!items.length"
            >
                No items
            </div>
        </div>
    </div>
</template>

<script lang='coffee'>
import EventBus from './event-bus'
import WeekPlannerItems from './mixins/week-planner-items'
export default
    name: 'week-planner-panel'
    mixins: [WeekPlannerItems]
    props:
        loading:
            type: Boolean
            default: false
        loadingText:
            type: String
            default: 'Loading...'
    inject: [
        'weekPlannerPanelProps'
    ]
    computed: {
        items: ->
            @weekPlannerPanelProps.items
        tab: ->
            @weekPlannerPanelProps.tab
        selected_parent_ui_item: ->
            @tab.parent_ui_item
        panel_selected_ui_item: ->
            @tab.panel_selected_ui_item
        weekable_properties: ->
            @selected_parent_ui_item.weekable_properties
        modes: ->
            modes = []
            for property, value of @weekable_properties
                modes.push
                    label: value.label
                    value: property
            return modes
        selected_parent_item_property: ->
            @tab.selected_parent_item_property
    }
    methods:
        setTabSelectedProperty: (property) ->
            @$store.commit 'week_planner/setTabSelectedProperty', { tab: @tab, property }
            if @panel_selected_ui_item
                EventBus.$emit @tab.events.toggle_select
</script>

<style lang="less">
@import (reference) "../../assets/app.less";
.week-planner-panel {
    width: 100%;
    position: relative;
    .panel-header {
        position: sticky;
        top: 0px;
        left: 0px;
        right: 0px;
        .mx-2;
        .py-2;
        border-bottom: 1px solid @background-light;
        background: #fff;
        z-index: 1;
    }
    .panel-items-container {
        .pa-2;
        .week-planner-item {
            .mb-2;
        }
        :last-child {
            .mb-0;
        }
    }
}
</style>
