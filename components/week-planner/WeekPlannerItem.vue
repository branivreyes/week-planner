<template>
    <div class="week-planner-item"
        :class="{ 
            comparator: is_comparator, 
            selected: ui_item.selected,
            'move-hour': move_hour,
            'cursor-not-allowed': isnt_clickable_as_comparator,
            clickable: is_clickable_as_comparator
        }"
        @click="click"
        v-loading="loading"
        ref="weekPlannerItem"
    >   
        <div 
            class="container"
            :class="{
                'cursor-pointer': selectable,
                'cursor-not-allowed': isnt_clickable_as_comparator
            }"
        >
            <div 
                class="supplementary-title"
                v-if="isPanel"
            >
                <slot name="supplementary-title"></slot>
            </div>
            <div 
                class="supplementary-title week-table top"
                v-if="isWeekTable"
            >
                <slot
                    name="placeholder"
                >
                    {{placeholder}}
                </slot>
            </div>
            <div class="rows-container">
                <slot></slot>
            </div>
        </div>
        <div>
            <div
                v-if="is_comparator"
                class="supplementary-title week-table text-xs-left mx-2"
            >
                <slot name="comparator-text"></slot>
            </div>
            <div 
                class="item-tools panel"
                @click.stop
                v-if="showTools"
            >
                <slot
                    name="tools"
                    :tooltips-delay="tooltips_delay"
                >
                </slot>
                <template
                    v-if="isPanel"
                >
                    <el-tooltip 
                        effect="dark" 
                        content="Delete all hours" 
                        placement="top"
                        :open-delay="tooltips_delay"
                    >
                        <i 
                            class="material-icons"
                            @click="onDestroyHourClicked(true)"
                        >
                            timer_off
                        </i>
                    </el-tooltip>
                    <el-tooltip 
                        effect="dark" 
                        :content="'Delete ' + placeholder.toLowerCase()" 
                        placement="top"
                        :open-delay="tooltips_delay"
                    >
                        <i 
                            class="material-icons"
                            @click="$emit('destroy-element')"
                        >
                            delete_forever
                        </i>
                    </el-tooltip>
                </template>
                <el-tooltip 
                    effect="dark" 
                    content="See overlaps" 
                    placement="top"
                    v-if="isWeekTable && has_collisions"
                    :open-delay="tooltips_delay"
                >
                    <el-badge 
                        :value="collisions_count"
                        type="primary"
                        style="display: flex;"
                        class="mr-2"
                    >
                        <el-popover
                            placement="top"
                            trigger="click"
                            ref="collisions"
                            title="Overlaps"
                        >
                            <div
                                style="display:flex;word-break: initial;"
                            >
                                <component
                                    v-for="(collision_item, i) in collision_items"
                                    :key="i"
                                    :is="collision_item.component"
                                    is-week-table
                                    :day="day"
                                    :hour="hour"
                                    :ui-item="collision_item"
                                    :item="collision_item.item"
                                    :tab="tab"
                                    style="max-width:200px;"
                                    :style="{marginLeft: i !== 0 ? '8px' : '0px'}"
                                    is-collision-popup
                                >
                                </component>
                            </div>
                        </el-popover>
                        <i 
                            class="material-icons"
                            v-popover:collisions
                        >
                            flip_to_front
                        </i>
                    </el-badge>
                </el-tooltip>
                <template
                    v-if="isWeekTable"
                >
                    <el-tooltip 
                        effect="dark" 
                        content="Move hour" 
                        placement="top"
                        :open-delay="tooltips_delay"
                        v-if="moveHour"
                    >
                        <i 
                            class="material-icons"
                            @click="followCursor"
                        >
                            shuffle
                        </i>
                    </el-tooltip>
                    <el-tooltip 
                        effect="dark" 
                        content="Delete hour" 
                        placement="top"
                        :open-delay="tooltips_delay"
                    >
                        <i 
                            class="material-icons"
                            @click="onDestroyHourClicked(false)"
                        >
                            delete_forever
                        </i>
                    </el-tooltip>
                </template>
            </div>
        </div>
    </div>
</template>

<script lang='coffee'>
import WeekPlannerItem from '~/ui-classes/WeekPlannerItem'
import WeekPlannerItemsAsync from './mixins/week-planner-items-async'
export default
    name: 'week-planner-item'
    inject: [
        'sharedWeekPlannerItemProps'
        'sharedWeekPlannerItemData'
        'onDestroyHourClicked'
        'showComparatorData'
        'selectItem'
    ]
    mixins: [WeekPlannerItemsAsync]
    props:
        onClick:
            type: Function
        selectable:
            type: Boolean
            default: true
        showTools:
            type: Boolean
            default: true
        placeholder:
            type: String
            default: ''
        moveHour:
            type: Boolean
            default: false
    data: ->
        selected: false
        show_tools_hover: false
        tooltips_delay: 1000
        el_item: null
        move_hour: false
    computed:
        isWeekTable: ->
            @sharedWeekPlannerItemProps.isWeekTable
        isPanel: ->
            @sharedWeekPlannerItemProps.isPanel
        ui_item: ->
            @sharedWeekPlannerItemProps.uiItem 
        is_collision_popup: ->
            @sharedWeekPlannerItemProps.isCollisionPopup 
        loading: ->
            @sharedWeekPlannerItemData.loading
        is_comparator: ->
            @sharedWeekPlannerItemData.is_comparator
        collision_items: ->
            @sharedWeekPlannerItemProps.collisionItems.filter (item) -> item.component isnt 'EmptyHour'
        day: ->
            @sharedWeekPlannerItemProps.day
        hour: ->
            @sharedWeekPlannerItemProps.hour
        tab: ->
            @sharedWeekPlannerItemProps.tab
        collisions_count: ->
            @collision_items.length
        has_collisions: ->
            @collisions_count > 1
        is_clickable: ->
            @onClick && !@is_collision_popup
        is_clickable_as_comparator: ->
            @is_clickable && @is_comparator
        isnt_clickable_as_comparator: ->
            !@is_clickable && @is_comparator
    methods:
        click: ->
            if @loading
                return
            if @is_clickable
                @onClick @selectItem
            else if @selectable
                @selectItem()
        onRightClickCancel: (e) ->
            @removeItemFromCursor()
            e.preventDefault()
        removeItemFromCursor: ->
            @el_item.parentNode.removeChild @el_item
            window.removeEventListener 'mousemove', @updateCursorXandYPosition
            document.removeEventListener 'contextmenu', @onRightClickCancel
            @el_item = null
            @move_hour = false
        updateCursorXandYPosition: ({clientX, clientY}) ->
            if typeof clientX isnt 'undefined'
                @el_item.style.left = clientX + "px"
                @el_item.style.top = clientY + "px"
        followCursor: ({clientX, clientY}) ->
            if @is_there_move_hour
                return
            @$emit 'move-hour'
            @move_hour = true
            @el_item = @$refs.weekPlannerItem.cloneNode true
            @el_item.style.left = clientX + "px"
            @el_item.style.top = clientY + "px"
            @setItemStyle()
            document.body.appendChild @el_item
            window.addEventListener 'mousemove', @updateCursorXandYPosition, false
            document.addEventListener 'contextmenu', @onRightClickCancel, false
        setItemStyle: ->
            @el_item.style['position'] = 'fixed'
            @el_item.style['z-index'] = 2000
            @el_item.style['width'] = '200px'
            @el_item.removeChild @el_item.childNodes[2]
    beforeDestroy: ->
        if @el_item
            @removeItemFromCursor()
</script>

<style scoped lang="less">
@import (reference) "../../assets/app.less";
.cursor-not-allowed {
    cursor: not-allowed;
}
.week-planner-item {
    position: relative;
    .lighter-border;
    .regular--text;
    border: 2px solid @base-border;
    border-radius: 4px;
    min-height: 100px;
    display: flex;
    justify-content: space-between;
    flex-direction: column;
    flex: 1;
    .cursor-not-allowed {
        cursor: not-allowed;
    }
    .placeholder-icon {
        .mr-1;
        .md-18;
        .placeholder--text;
    }
    &.move-hour {
        border: 2px solid @warning;
    }
    .container {
        .pa-2;
    }
    .supplementary-title {
        text-align: right;
        .regular--text;
        .supplementary;
        .mb-2;
        &.week-table {
            .secondary-text;
            font-style: italic;
        }
        &.top {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            span {
                display: flex;
                align-items: center;
            }
        }
    }
    &.comparator {
        background-color: #F5F0EB;
        border-color: #E6E1DC;
        color: #666360 !important;
        .item-tools {
            background-color: #EFE8E2;
            &.panel {
                box-shadow: inset 0 1px 0 0 #E6E1DC;
            }
        }
        &.clickable {
            background: #F5FCF0;
            border-color: #CBEBB1;
            cursor: pointer;
            .item-tools {
                background-color: #E4F5D6;
                &.panel {
                    box-shadow: inset 0 1px 0 0 #DFF2CE;
                }
            }
        }
    }
    &.selected {
        border: 2px solid @primary;
    }
    .item-tools {
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 10;
        .pa-2;
        background: #E2E7EF;
        i {
            cursor: pointer;
            opacity: 0.5;
            &:hover {
                .primary--text;
                opacity: 1;
            }
        }
        &.panel {
            box-shadow: inset 0 1px 0 0 #D6DDE8;
        }
        &.weektable {
            position: absolute;
            left: 0px;
            top: 0px;
            bottom: 0px;
            box-shadow: inset -1px 0 0 #D6DDE8;
        }
    }
}

</style>