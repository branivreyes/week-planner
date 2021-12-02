<template>
    <div class="text-xs-right mb-2 week-table-tools">
        <component
            :is="parent_ui_item.tools_component"
            :parent-ui-item="parent_ui_item"
            is-week-table
        >
        </component>
        <el-radio-group
            v-model="shift"
            size="mini"
            @change="$emit('filter-hours', $event)"
        >
            <el-radio-button label="all">
                All
            </el-radio-button>
            <el-radio-button label="M">
                Morning
            </el-radio-button>
            <el-radio-button label="X">
                Mixed
            </el-radio-button>
            <el-radio-button label="V">
                Afternoon
            </el-radio-button>
        </el-radio-group>
    </div>
</template>

<script lang='coffee'>
import WeekPlannerTab from '~/ui-classes/WeekPlannerTab'
import WeekPlannerSharedTools from './mixins/week-planner-shared-tools'
export default
    name: 'week-planner-week-table-tools'
    mixins: [WeekPlannerSharedTools]
    props:
        tab:
            type: Object
            default: new WeekPlannerTab()
    data: ->
        shift: 'all'
    computed:
        parent_ui_item: ->
            @tab.parent_ui_item
</script>

<style lang="less">
.week-table-tools {
    display: flex;
    align-items: center;
    justify-content: space-between;
}
</style>
