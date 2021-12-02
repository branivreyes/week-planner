<template>
    <WeekPlannerHeader>
        <WeekPlannerHeaderRow>
            <WeekPlannerHeaderCol
                label="Teacher"
                :value="parentItem.general_data.full_name"
            />
        </WeekPlannerHeaderRow>
    </WeekPlannerHeader>
</template>

<script lang='coffee'>
import WeekPlannerHeader from '../mixins/week-planner-header.coffee'
import Teacher from '~/classes/Teacher'
export default
    name: 'teacher-header'
    props:
        parentItem:
            default: -> new Teacher()
    mixins: [WeekPlannerHeader]
</script>