<template>
    <WeekPlannerTools>
        <WeekPlannerToolsItem 
            icon="account_balance"
            description="Clases"
            weekable-property="schedules"
        />
    </WeekPlannerTools>
</template>

<script lang='coffee'>
import WeekPlannerToolsMixin from '../mixins/week-planner-tools'
export default
    name: 'group-tools'
    mixins: [
        WeekPlannerToolsMixin
    ]
</script>