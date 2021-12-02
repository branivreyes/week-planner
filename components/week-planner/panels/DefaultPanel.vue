<template>
    <WeekPlannerPanel
    >
    </WeekPlannerPanel>
</template>

<script lang='coffee'>
import WeekPlannerTab from '~/ui-classes/WeekPlannerTab'
import WeekPlannerPanelMixin from '../mixins/week-planner-panel.coffee'
export default
    name: 'default-panel'
    mixins: [WeekPlannerPanelMixin]
</script>