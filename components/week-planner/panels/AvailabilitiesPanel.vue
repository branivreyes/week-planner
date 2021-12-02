<template>
    <WeekPlannerPanel
        :loading="loading"
        loading-text="Enviando..."
    >
        <div
            slot="header-tools"
            class="mt-2"
        >
            <template
                v-if="show_add_and_send"
            >
                <el-button 
                    icon="el-icon-plus" 
                    circle
                    size="mini"
                    @click="showAvailabilityModal"
                />
                <el-button 
                    icon="el-icon-arrow-up" 
                    circle
                    size="mini"
                    @click="sendAvailabilities('E')"
                    class="ml-1"
                />
            </template>
            <template
                v-if="show_approve_and_reject"
            >
                <el-button 
                    icon="el-icon-check" 
                    circle
                    size="mini"
                    @click="sendAvailabilities('A')"
                    class="ml-1"
                />
                <el-button 
                    icon="el-icon-circle-close" 
                    circle
                    size="mini"
                    @click="sendAvailabilities('P')"
                    class="ml-1"
                />
                </template>
            <AvailabilityTeacherModal 
                ref="availabilityModal"
                :teacher-id="tab.parent_ui_item.item.id"
                @stored="addAvailability"
            />
        </div>
    </WeekPlannerPanel>
</template>

<script lang='coffee'>
import AvailabilityTeacherModal from '../modals/AvailabilityTeacherModal'
import WeekPlannerPanelMixin from '../mixins/week-planner-panel.coffee'
import WeekPlannerAvailabilityTeacher from '~/ui-classes/WeekPlannerAvailabilityTeacher'
export default
    name: 'availabilities-panel'
    mixins: [WeekPlannerPanelMixin]
    components: {
        AvailabilityTeacherModal
    }
    inject: [
        'weekPlannerAdditionalData'
    ]
    data: ->
        loading: false
    computed:
        is_admin: ->
            @$hasRole 'admin'
        is_principal: ->
            @$hasRole 'direc'
        is_tab_logged_teacher: ->
            @$store.state.auth.user.teacher.id is @tab_teacher.id
        tab_teacher: ->
            @tab.parent_ui_item.item
        show_add_and_send: ->
            @is_tab_logged_teacher or @is_admin
        show_approve_and_reject: ->
            @is_admin or @is_principal
    methods:
        showAvailabilityModal: ->
            @$refs.availabilityModal.show = true
        addAvailability: (availability) ->
            @$_addItemToWeekableProperty
                ui_item: new WeekPlannerAvailabilityTeacher({
                    item: availability
                    parent_ui_item: @tab.parent_ui_item
                })
                data_property: 'availability_teachers'
        sendAvailabilities: (status) ->
            @loading = true
            @api$.AvailabilityTeacher.updateStatus
                teacher_id: @tab_teacher.id
                period_id: @weekPlannerAdditionalData.selected_period.id
                status: status
            .then ({error, message}) =>
                @loading = false
                if !error
                    @$_updateAllPanelItems { status }
                    @$notify {
                        title: 'Mensaje'
                        message
                        type: 'success'
                    }
            .catch (err) =>
                @$notify.error
                    title: 'Error'
                    message: 'Hubo un error desconocido al actualizar las disponibilidades.'
</script>