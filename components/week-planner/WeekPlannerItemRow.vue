<template>
    <div 
        class="week-planner-item-row"
        :class="isWeekTable ? 'text-xs-center' : ''"
    >
        <div 
            class="label"
            v-if="week_title_condition"
        >
            {{label}}
        </div>
        <div 
            class="value"
            :class="!week_title_condition ? 'row-title' : ''"
        >
            <component
                v-if="show_tools_component"
                :is="_comparator.tools_component"
                :parent-ui-item="_comparator"
                :tab="tab"
                is-panel
            >
            </component>
            <slot name="value">{{value}}</slot>
        </div>
    </div>
</template>

<script lang="coffee">
import WeekPlannerParentItem from '~/ui-classes/WeekPlannerParentItem'
import WeekPlannerSharedTools from './mixins/week-planner-shared-tools'
export default
    name: 'week-planner-item-row'
    inject: ['sharedWeekPlannerItemProps']
    mixins: [WeekPlannerSharedTools]
    props:
        label: String
        weekTableTitle: Boolean
        value: String
        comparator: String
    computed:
        week_title_condition: ->
            !@weekTableTitle || @isPanel
        isWeekTable: ->
            @sharedWeekPlannerItemProps.isWeekTable
        isPanel: ->
            @sharedWeekPlannerItemProps.isPanel
        uiItem: ->
            @sharedWeekPlannerItemProps.uiItem
        tab: ->
            @sharedWeekPlannerItemProps.tab
        show_tools_component: ->
            @isPanel && @comparator && (@uiItem.selected || @show_if_pin)
        _comparator: ->
            key = @uiItem.comparators[@comparator]?.default.item_class.api_path + @uiItem.item[@comparator]
            @tab.comparators[key] || new WeekPlannerParentItem()
        counts: ->
            counts =
                true: 0
                false: 0
                null: 0
            for key, weekable_property of @_comparator.weekable_properties
                ++counts[weekable_property.always_show_in_weektable]
            return counts
        show_if_pin: ->
            return !!@counts.true
</script>

<style scoped lang="less">
@import (reference) "../../assets/app.less";
.week-planner-item-row {
    .small-body;
    .label {
        font-weight: bold;
    }
    .mb-2;
    &:last-of-type {
        .mb-0;
    }
    .row-title {
        font-weight: bold;
        .small-title;
    }
    .comparator-tools {
        i {
            .secondary-text;
            font-size: 20px; 
        }
    }
}
</style>