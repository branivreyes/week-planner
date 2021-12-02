<template>
    <WeekPlannerHeader>
        <WeekPlannerHeaderRow>
            <WeekPlannerHeaderCol
                label="Header"
                value="header_component"
            />
        </WeekPlannerHeaderRow>
    </WeekPlannerHeader>
</template>

<script lang='coffee'>
import WeekPlannerHeader from '../mixins/week-planner-header.coffee'
export default
    name: 'default-header'
    mixins: [WeekPlannerHeader]
</script>