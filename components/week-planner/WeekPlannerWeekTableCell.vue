<template>
    <component
        is-week-table
        :is="component" 
        :day="day"
        :hour="hour"
        :ui-item="showing_item"
        :item="showing_item.item"
        :tab="tab"
        :collision-items="sorted"
    >
    </component>
</template>

<script lang="coffee">

import EmptyHour from './items/EmptyHour'
import HourSchedule from '~/classes/HourSchedule'
import WeekPlannerTab from '~/ui-classes/WeekPlannerTab'
import WeekPlannerItems from './mixins/week-planner-items'
export default
    name: 'week-table-cell'
    mixins: [WeekPlannerItems]
    components: {
        EmptyHour
    }
    props:
        uiItems:
            type: Object
        hour:
            type: Object
        day:
            type: Object
        tab:
            type: Object
            default: -> new WeekPlannerTab()
    data: ->
        showing_index: 0
    methods:
        sortByPriority: (a, b) ->
            b.priority - a.priority
    computed:
        ui_items_array: ->
            Object.values @uiItems
        sorted: ->
            @ui_items_array.sort @sortByPriority
        higher_ui_item: ->
            @sorted[@showing_index]
        component: ->
            @showing_item.component
        parent_item_child: ->
            @sorted.filter (item) => 
                @tab.parent_ui_item.key is item.parent_ui_item.key
        parent_item_higher_child: ->
            @parent_item_child?[0]
        showing_item: ->
            @parent_item_higher_child || @higher_ui_item
</script>

<style scoped>

</style>