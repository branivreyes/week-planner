<template>
    <div class="week-planner-item-tools"
    >
        <WeekPlannerToolsItem
            icon="search"
            description="Open in a new tab"
            load-tab
            v-if="sharedToolsData.isPanel"
        />
        <WeekPlannerToolsItem
            icon="remove_red_eye"
            description="All"
            all
            :default="allDefault"
        />
        <slot></slot>
    </div>
</template>

<script lang='coffee'>
import WeekPlannerToolsItem from './WeekPlannerToolsItem'
export default
    name: 'week-planner-tools'
    props:
        allDefault:
            type: String
    inject: [
        'sharedToolsData'
    ]
    components: {
        WeekPlannerToolsItem
    }
    computed:
        parentUiItem: ->
            @sharedToolsData.parentUiItem
</script>