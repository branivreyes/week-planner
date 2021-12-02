<template>
    <WeekPlannerTools
    >
        <WeekPlannerToolsItem 
            icon="donut_large"
            description="Availabilities"
            weekable-property="availability_teachers"
        />
        <WeekPlannerToolsItem 
            icon="donut_small"
            description="Academic Assignments"
            weekable-property="academic_assignments"
            :default="show_extra_data"
        />
        <WeekPlannerToolsItem 
            icon="account_balance"
            description="Classes"
            weekable-property="schedules"
            :default="show_extra_data"
        />
    </WeekPlannerTools>
</template>

<script lang='coffee'>
import WeekPlannerToolsMixin from '../mixins/week-planner-tools'
import WeekPlannerGroup from '~/ui-classes/WeekPlannerGroup'
export default
    name: 'teacher-tools'
    mixins: [
        WeekPlannerToolsMixin
    ]
    computed:
        show_extra_data: ->
            return
            if @tab.parent_ui_item instanceof WeekPlannerGroup
                return 'false'
</script>