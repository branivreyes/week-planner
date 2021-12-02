<template>
    <div class="week-planner-week-table-container">
        <WeekPlannerWeekTableTools 
            :tab="tab"
            @filter-hours="filterHours"
        />
        <table class="week-planner-week-table">
            <tr>
                <th width="100">
                    <div class="headers first-column">
                        <div>Hour</div>
                    </div>
                </th>
                <th
                    v-for="(day, i) in $store.getters.work_days"
                    :key="'d' + i"
                    width="100%"
                >
                    <div class="headers">
                        <div>{{day.name}}</div>                        
                    </div>
                </th>
            </tr>
            <tr
                v-for="(hour, hour_index) in hours"
                :key="'h' + hour_index"
                v-show="showHourRow(hour)"
            >
                <td>
                    <div class="headers hours first-column">
                        {{hour.start_hour}} - {{hour.end_hour}}
                    </div>
                </td>
                <template
                    v-if="hour.id"
                >
                    <td
                        v-for="(day, day_index) in days"
                        :key="'d' + day_index + 'h' + hour_index"
                    >
                        <div class="table-cell-wrapper">
                            <WeekPlannerWeekTableCell
                                :ui-items="getUiItems(day, hour)"
                                :hour="hour"
                                :day="day"
                                :tab="tab"
                            />
                        </div>
                    </td>
                </template>
                <td
                    v-else
                    :colspan="days.length"
                >
                    <div class="headers hours first-column">
                        <div>BREAK</div>                        
                    </div>
                </td>
            </tr>
        </table>
    </div>
</template>

<script lang='coffee'>
import WeekPlannerItem from './WeekPlannerItem'
import WeekPlannerWeekTableTools from './WeekPlannerWeekTableTools'
import { clone } from 'lodash'
import WeekPlannerWeekTableCell from './WeekPlannerWeekTableCell'
import WeekPlannerTab from '~/ui-classes/WeekPlannerTab'
import Hour from '~/classes/Hour'
export default
    name: 'week-planner-week-table'
    props:
        tableData:
            type: Object
        tab:
            type: Object
            default: -> new WeekPlannerTab()
        totalHoursCount:
            type: Number
            default: 0
    components: {
        WeekPlannerItem
        WeekPlannerWeekTableTools
        WeekPlannerWeekTableCell
    }
    data: ->
        shift: 'all'
    computed:
        hours: ->
            hours = clone @$store.state.hours
            hours.splice 4, 0, new Hour({start_hour: '11:00', end_hour: '11:30'})
            return hours
        days: ->
            @$store.getters.work_days
    methods:
        getUiItems: (day, hour) ->
            @tableData?[hour.key]?[day.key] || null
        filterHours: (value) ->
            @shift = value
        showHourRow: (hour) ->
            @shift is 'all' || hour.turn is @shift || (!hour.id and (@shift is 'all' || @shift is 'M'))
</script>

<style lang="less">
@import (reference) "../../assets/app.less";
.week-planner-week-table-container {
    .pa-2;
}

.table-cell-wrapper {
    display: flex;
}

.week-planner-week-table {
    width: calc(100% + 10px);
    border-collapse: separate;
    border-spacing: 4px;
    margin-top: -5px;
    margin-left: -5px;
    table-layout: fixed;
    td, th {
        height: 1px;
        & > div {
            height: 100%;
        }
    }
    .headers {
        border-radius: 4px;
        text-align: center;
        font-weight: bold;
        .base-border;
        .regular--text;
        //.pa-2;
        &.hours {
            .small-body;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        & > div {
            .pa-2;
        }
    }
}
</style>
