<template>
    <WeekPlannerItem
        :on-click="get_on_click"
        placeholder="Availability"
    >
        <template
            slot="placeholder"
        >
            <i class="material-icons placeholder-icon">
                donut_large
            </i>
            Availability
            <i class="ml-1 material-icons md-18 success--text"
                v-if="is_available"
            >
                check_circle
            </i>
            <el-popover
                placement="top-end"
                title="Taken by:"
                width="200"
                trigger="hover"
                v-else
            >
                <component
                    is-week-table
                    :is="taken_by_ui.component"
                    :ui-item="taken_by_ui"
                    :item="taken_by_ui.item"
                    :tab="tab"
                    :day="day"
                    :hour="hour"
                    style="word-break: initial;"
                >

                </component>
                <i 
                    class="ml-1 material-icons md-18 warning--text"
                    slot="reference"
                >
                    remove_circle
                </i>
            </el-popover>
        </template>
        <template slot="supplementary-title">
            Assigned hours: {{hours_count}}
        </template>
        <WeekPlannerItemRow
            label="Career"
            :value="item.career.name"
            week-table-title
        />
        <WeekPlannerItemRow
            label="Status"
            v-if="isPanel"
        >
            <template 
                slot="value"
            >
                <el-tag
                    size="mini"
                    :type="status_type"
                    class="mt-1"
                >
                    {{item.status_string}}
                </el-tag>
            </template>
        </WeekPlannerItemRow>
        <template
            slot="comparator-text"
        >
            {{teacher.general_data.full_name}}
        </template>
    </WeekPlannerItem>
</template>

<script lang='coffee'>
import WeekPlannerItemMixin from '../mixins/week-planner-item'
import WeekPlannerAvailabilityTeacher from '~/ui-classes/WeekPlannerAvailabilityTeacher'
import WeekPlannerScheduleByGroup from '~/ui-classes/WeekPlannerScheduleByGroup'
import WeekPlannerScheduleByTeacher from '~/ui-classes/WeekPlannerScheduleByTeacher'
import HourSchedule from '~/classes/HourSchedule'
import WeekPlannerItems from '../mixins/week-planner-items-async'
export default
    name: 'availability-teacher'
    mixins: [
        WeekPlannerItems
        WeekPlannerItemMixin
    ]
    data: ->
        types:
            A: 'success'
            P: 'warning'
            E: ''
    methods:
        onClick: ->
            if @isWeekTable and @is_available
                @addHour()

            # To allow get clicked by other properties
            if @selected_parent_item_property isnt 'availability_teachers' and
            @panel_selected_ui_item
                return

            @$_selectItem()
        addHour: ->
            if !@panel_selected_ui_item
                return
            if @panel_selected_ui_item instanceof WeekPlannerAvailabilityTeacher
                return
            @$_addHourToSelectedPanelUiItem @hour_schedule
    computed:
        status_type: ->
            @types[@item.status]
        teacher: ->
            @week_planner_data.teachers[@item.teacher_id]
        hour_schedule_mapped: ->
            new HourSchedule @hour_schedule
        is_available: ->
            @hour_schedule_mapped.is_available
        taken_by: ->
            if !@is_available
                return @week_planner_data[@hour_schedule.taken_by_type][@hour_schedule.taken_by_id]
        taken_by_ui: ->
            @tab.ui_items[@hour_schedule.taken_by_type][@hour_schedule.taken_by_id]
        get_on_click: ->
            if @selected_parent_item.career_id is @item.career_id
                return @onClick
            return null
            
</script>