<template>
    <WeekPlannerItem>
        <template
            slot="placeholder"
        >
            <i class="material-icons placeholder-icon">
                donut_small
            </i>
            Academic Assignment
        </template>
        <template slot="supplementary-title">
            {{hours_count}} assigned hours
        </template>
        <WeekPlannerItemRow
            label="Activity"
            :value="item.type.description"
            week-table-title
        />
        <WeekPlannerItemRow
            label="Career"
            :value="item.career.name"
        />
        <template
            slot="comparator-text"
        >
            {{teacher.general_data.full_name}}
        </template>
    </WeekPlannerItem>    
</template>

<script lang='coffee'>
import WeekPlannerItemMixin from '../mixins/week-planner-item'
export default
    name: 'academic-assignment'
    mixins: [
        WeekPlannerItemMixin
    ]
    computed:
        teacher: ->
            @week_planner_data.teachers[@item.teacher_id]
</script>