<template>
    <WeekPlannerHeader>
        <WeekPlannerHeaderRow>
            <WeekPlannerHeaderCol
                label="Group"
                :value="parentItem.group_label"
                icon="group"
            />
            <WeekPlannerHeaderCol
                label="Shift"
                :value="parentItem.turn.description"
                icon="schedule"
            />
        </WeekPlannerHeaderRow>
        <WeekPlannerHeaderRow>
            <WeekPlannerHeaderCol
                :colspan="2"
                label="Career"
                :value="parentItem.career.name"
            />
        </WeekPlannerHeaderRow>
    </WeekPlannerHeader>
</template>

<script lang='coffee'>
import WeekPlannerHeader from '../mixins/week-planner-header.coffee'
import Group from '~/classes/Group'
export default
    name: 'group-header'
    props:
        parentItem:
            default: -> new Group()
    mixins: [WeekPlannerHeader]
</script>