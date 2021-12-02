<template>
    <WeekPlannerItem
        :on-click="onClick"
        :show-tools="false"
        :selectable="false"
        class="cursor-pointer"
    >
    </WeekPlannerItem>
</template>

<script lang='coffee'>
import WeekPlannerItemMixin from '../mixins/week-planner-item'
import EventBus from '../event-bus'
export default
    name: 'empty-hour'
    mixins: [
        WeekPlannerItemMixin
    ]
    computed:
        panel_selected_ui_item: ->
            @tab.panel_selected_ui_item
    methods:
        onClick: ->
            @$_addHourToSelectedPanelUiItem()
</script>