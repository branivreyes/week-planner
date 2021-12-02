<template>
    <el-tabs
        :value="selected_tab_name"
        type="border-card"
        editable
        class="week-planner-tabs"
        :class="{'solo': weekPlannerSolo}"
        @tab-add="addTab"
        @tab-remove="removeTab"
        @tab-click="setSelectedTabName"
    >
        <el-tab-pane
            v-for="(tab) in tabs"
            :key="tab.name"
            :label="tab.label"
            :name="tab.name"
        >
            <WeekPlannerEmptyTab
                v-if="tab.name === 'new-tab'"
            />
            <WeekPlannerWorkspace 
                :tab="tab"
                v-else
            />
        </el-tab-pane>
    </el-tabs>
</template>

<script lang='coffee'>
import WeekPlannerWorkspace from './WeekPlannerWorkspace'
import WeekPlannerEmptyTab from './WeekPlannerEmptyTab'
export default
    name: 'week-planner-tabs'
    components: {
        WeekPlannerWorkspace
        WeekPlannerEmptyTab
    }
    inject: [
        'weekPlannerSolo'
    ]
    computed:
        tabs: ->
            @$store.getters['week_planner/tabs']
        selected_tab_name: ->
            @$store.state.week_planner.selected_tab_name
    methods:
        addTab: (tab_data) ->
            @$store.dispatch 'week_planner/addTab', tab_data
        removeTab: (tab_name) ->
            @$store.dispatch 'week_planner/removeTab', tab_name
        setSelectedTabName: (tab) ->
            @$store.commit 'week_planner/setSelectedTabName', tab.name
</script>

<style lang="less">
@import (reference) "../../assets/app.less";
.week-planner-tabs {
	height: 100%;
	display: flex;
    flex-direction: column;
    &.solo {
        .el-tabs__header {
            display: none;
        }
    }
    .el-tab-pane {
        height: 100%;
    }
	.el-tabs__header .el-tabs__new-tab {
		.mr-2;
		background: #fff;
		height: auto;
		margin-top: 10px;
	}
	.el-tabs__content {
		flex: 1;
		.pa-0;
	}
	.el-tabs__item {
		height: 41px;
	}
}
</style>
