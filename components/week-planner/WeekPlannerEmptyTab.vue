<template>
    <div
        v-loading="loading"
        :element-loading-text="loading_text"
        style="overflow-y: auto;"
        class="wrapper"
    >
        <el-row
            type="flex"
            align="middle"
            class="mx-3 mt-3"
            :gutter="20"
        >
            <el-col
                :span="12"
            >
                <el-input 
                    v-model="search_text"
                    placeholder="Search"
                    size="small"
                />
            </el-col>
            <el-col
                :span="12"
            >
                <span class="regular--text body mr-2">
                    Search by:
                </span>
                <el-radio-group
                    class="text-xs-right"
                    v-model="by"
                    size="small"
                    @change="getCareers"
                >
                    <el-radio-button label="groups">Groups</el-radio-button>
                    <el-radio-button label="teachers">Teachers</el-radio-button>
                </el-radio-group>
            </el-col>
        </el-row>
        <el-tree
            :data="careers"
            node-key="id"
            default-expand-all
            :expand-on-click-node="false"
            class="mt-3 py-2"
            :filter-node-method="filterNode"
            ref="careersTree"
            @node-click="loadTab"
        >
            <span class="custom-tree-node" slot-scope="{ node }">
                <span>{{ node.label }}</span>
            </span>
        </el-tree>    
    </div>
</template>

<script lang='coffee'>
import WeekPlannerGroup from '~/ui-classes/WeekPlannerGroup'
import WeekPlannerTeacher from '~/ui-classes/WeekPlannerTeacher'
export default
    name: 'week-planner-empty-tab'
    inject: [
        'weekPlannerLoadTab'
        'weekPlannerAdditionalData'
    ]
    data: ->
        careers: []
        by: 'groups'
        search_text: ''
        loading: false
        payload:
            groups: 
                translate: 'groups'
                class: WeekPlannerGroup
                search_fn: (_group) ->
                    {grade, group} = _group
                    "#{grade + group} #{grade}-#{group} #{grade} - #{group} #{grade} #{group} #{_group.career.name} #{_group.career.abr}"
            teachers: 
                translate: 'teachers'
                class: WeekPlannerTeacher
                search_fn: (teacher) ->
                    general_data = teacher.general_data
                    "#{general_data.full_name} #{general_data.full_name_last} #{general_data.short_name} #{general_data.short_name_first}"
        items: {}
    watch:
        search_text: (val) ->
            @$refs.careersTree.filter val
    methods:
        filterNode: (value, data) ->
            if !value 
                return true
            search_string = ''
            if data.children
                search_string = data.label
            else
                search_string = @type.search_fn @items[data.id]
            return search_string.toLowerCase().indexOf(value.toLowerCase()) isnt -1
        loadTab: ({id, children}) ->
            if children
                return
            @weekPlannerLoadTab id, @type.class
        getCareers: ->
            @loading = true
            { tree_data, items } = await @api$.Career.careersWithGroupsOrTeachers {
                by: @by
                period_id: @weekPlannerAdditionalData.selected_period.id
            }
            @items = items
            @careers = tree_data
            @loading = false
    computed:
        loading_text: ->
            'Loading ' + @type.translate + '...'
        type: ->
            @payload[@by]
    created: ->
        @getCareers()
</script>

<style lang="less" scoped>
.wrapper {
    position: absolute;
    left: 0px;
    right: 0px;
    bottom: 0px;
    top: 0px;
}
</style>
