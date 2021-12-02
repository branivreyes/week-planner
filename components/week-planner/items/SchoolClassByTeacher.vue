<template>
    <WeekPlannerItem
        move-hour
    >
        <template
            slot="placeholder"
        >
            <i class="material-icons placeholder-icon">
                account_balance
            </i>
            Class
        </template>
        <template slot="supplementary-title">
            Assigned hours: {{hours_count}}
        </template>
        <template
            slot="comparator-text"
        >
            {{show_by_group ? teacher.general_data.full_name : group.group_label}}
        </template>
        <WeekPlannerItemRow
            label="Group"
            :value="group.group_label"
            v-if="show_by_group"
            week-table-title
            comparator="group_id"
        />
        <WeekPlannerItemRow
            label="Subject"
            :value="subject.name"
        />
        <WeekPlannerItemRow
            label="Teacher"
            :value="teacher.general_data.full_name"
            week-table-title
            v-if="show_by_teacher"
            comparator="teacher_id"
        >
            <template 
                slot="value"
            >
                <span>
                    {{teacher.general_data.full_name}}
                </span>
            </template>
        </WeekPlannerItemRow>
    </WeekPlannerItem>
</template>

<script lang='coffee'>
import WeekPlannerItemMixin from '../mixins/week-planner-item'
import { 
    WeekPlannerSchedule 
    WeekPlannerTeacher
} from '~/ui-classes'
import { 
    Schedule 
    Teacher
    Subject
    Group
} from '~/classes'
export default
    name: 'school-class-by-teacher'
    mixins: [
        WeekPlannerItemMixin
    ]
    props:
        uiItem:
            default: -> new WeekPlannerSchedule()
        item:
            default: -> new Schedule()
    computed:
        show_by_group: ->
            @uiItem.show_by is 'group'
        show_by_teacher: ->
            @uiItem.show_by is 'teacher'
        teacher: ->
            @week_planner_data.teachers[@item.teacher_id] || new Teacher()
        subject: ->
            @week_planner_data.subjects[@item.subject_id] || new Subject()
        group: ->
            @week_planner_data.groups[@item.group_id] || new Group()
        teachers: ->
            @$store.state.week_planner.teachers_by_career[@group.career_id]
    methods:
        $_afterSaveHour: ({will_delete, data}) ->
            if will_delete
                @$parent.$emit('will-delete-attendances', data)
        setTeacher: (teacher_id) ->
            cloned = JSON.parse(JSON.stringify(@item))
            cloned.teacher_id = teacher_id
            {error, message, item} = await @api$.Schedule.update cloned
            if !error
                teacher = @week_planner_data.teachers[teacher_id]
                @$_hiddeWeekableDataOfUiItem @uiItem
                @$_updateItem
                    item: @item
                    data: { teacher_id, teacher }
                if @uiItem.selected
                    @$_loadComparators()
            if error
                @$notify.error {
                    title: 'Error'
                    message
                    duration: 0
                }
</script>