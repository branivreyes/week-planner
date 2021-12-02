<template>
    <el-popover
        placement="top"
        trigger="hover"
        :open-delay="250"
    >
        <template
            v-if="!custom && !loadTab"
        >
            <div
                class="mb-1"
            >
                <strong>{{description}}</strong>
                <span
                    v-if="!disabled && !isWeekTable"
                >
                </span>
                <span
                    v-if="disabled"
                >
                    this function is disabled.
                </span>
            </div>
            <el-button-group
                style="width: 100%;"
                v-if="!disabled"
            >
                <el-button 
                    size="mini"
                    style="width: 50%;"
                    :type="property_value === 'true' ? 'success' : ''"
                    @click="toggle('true')"
                    v-if="!isWeekTable"
                >
                    Pin
                </el-button>
                <el-button 
                    size="mini"
                    :style="{ width: isWeekTable ? '100%' : '50%' }"
                    :type="property_value === 'false' ? 'warning' : ''"
                    @click="toggle('false')"
                >
                    {{property_value === 'false' ? 'Show' : 'Hide'}}
                </el-button>
            </el-button-group>
        </template>
        <strong
            v-else
        >
            {{description}}
        </strong>
        <i 
            slot="reference"
            :class="icon_class"
            class="material-icons"
            @click.stop="openTab"
        >
            {{icon}}
        </i>
    </el-popover>
</template>

<script lang='coffee'>
export default
    name: 'week-planner-tools-item'
    props:
        description: String
        icon: String
        weekableProperty: String
        all:
            type: Boolean
            default: false
        default:
            type: null
        disabled:
            type: Boolean
            default: false
        custom:
            type: Boolean
            default: false
        loadTab:
            type: Boolean
            default: false
    inject: [
        'sharedToolsData'
        'weekPlannerLoadTab'
    ]
    computed:
        parentUiItem: ->
            @sharedToolsData.parentUiItem
        isWeekTable: ->
            @sharedToolsData.isWeekTable
        property_value: ->
            if @all
                return @all_value
            return @weekable_property?.always_show_in_weektable
        icon_class: ->
            if @property_value isnt 'null'
                if @property_value is 'true'
                    return 'success--text'
                if @property_value is 'false'
                    return 'warning--text'
            return 'secondary-text'
        counts: ->
            counts =
                true: 0
                false: 0
                null: 0
            for key, weekable_property of @parentUiItem.weekable_properties
                ++counts[weekable_property.always_show_in_weektable]
            return counts
        all_value: ->
            count = Object.keys @parentUiItem.weekable_properties
                .length
            for key, value of @counts
                if value is count
                    return key
            return undefined
        weekable_property: ->
            @parentUiItem.weekable_properties[@weekableProperty]
    methods:
        toggle: (value) ->
            if @property_value is value
                value = 'null'
            if @all
                @updateAll value
            else
                @update value
        updateAll: (value) ->
            @$store.commit 'week_planner/updateWeekablePropertiesAlwaysShow', {
                ui_item: @parentUiItem
                value
            }
        openTab: ->
            if @loadTab
                @weekPlannerLoadTab @parentUiItem.item.id, @parentUiItem.constructor
        update: (value) ->
            item = @weekable_property
            data = {
                always_show_in_weektable: value
            }
            @$store.commit 'week_planner/updateItem', { item, data }
    created: ->
        if @default is undefined
            return
        if @all 
            @updateAll @default
        if @weekableProperty
            @update @default
</script>

<style scoped lang="less">
@import (reference) "~assets/app.less";
i {
    font-size: 20px; 
    &:hover {
        .primary--text;
        cursor: pointer;
    }
}

</style>
