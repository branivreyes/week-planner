<template>
    <WeekPlannerPanel
        @will-delete-attendances="showWillDeleteModal"
    >
        <el-dialog
            title="Se eliminarán asistencias"
            :visible.sync="show_modal"
            width="30%"
        >
            <div
                class="mb-2"
            >
                Se eliminarán las asistencias de estos días debido a que sobran en el mes.
            </div>
            <ul
                class="days-to-delete"
            >
                <li
                    v-for="(day, i) in days_to_delete"
                    :key="i"
                >
                    {{createDayDescription(day)}}
                </li>
            </ul>
            <div class="primary--text">
                Ver lista de asistencia en nueva pestaña
            </div>
            <span slot="footer">
                <el-button @click="show_modal = false">Cancelar</el-button>
                <el-button type="primary" @click="show_modal = false">Aceptar</el-button>
            </span>
        </el-dialog>
    </WeekPlannerPanel>
</template>

<script lang='coffee'>
import WeekPlannerPanelMixin from '../mixins/week-planner-panel.coffee'
import WeekPlannerGroup from '~/ui-classes/WeekPlannerGroup'
import { keyBy } from 'lodash'
import { mapMutations } from 'vuex'
import spanish_days from '~/static/spanish_days'
import spanish_months from '~/static/spanish_months'
export default
    name: 'schedules-panel'
    mixins: [WeekPlannerPanelMixin]
    data: ->
        show_modal: false
        days_to_delete: []
    computed:
        parent_ui_item: ->
            @tab.parent_ui_item
    methods: {
        mapMutations('week_planner', [
            'addData'
            'addTeachersToCareer'
        ])...
        teachersAlreadyLoaded: (career_id) ->
            !!@$store.state.week_planner.teachers_by_career[career_id]
        showWillDeleteModal: (data) ->
            console.log 'WILL DELETEE'
            @days_to_delete = data
            @show_modal = true
        createDayDescription: ({day_of_week, day, month}) ->
            "#{spanish_days[day_of_week].name}, #{day} de #{spanish_months[month - 1]}"
    }
    created: ->
        if @parent_ui_item instanceof WeekPlannerGroup
            career_id = @parent_ui_item.item.career_id
            if @teachersAlreadyLoaded(career_id)
                return
            @api$.Teacher.index { no_paginate: true, career_id }
            .then ({data}) =>
                teachers = keyBy data, 'id'
                @addData { teachers }
                @addTeachersToCareer { [career_id]: teachers }
</script>

<style lang="less" scoped>
.days-to-delete {
    li {
        font-weight: bold;
    }
}
</style>
