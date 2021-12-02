<template>
    <WeekPlannerPanel
    >
        <div
            slot="header-tools"
            class="mt-2"
        >
            <el-button 
                icon="el-icon-plus" 
                circle
                size="mini"
                @click="showAcademicAssignmentModal"
            />
            <AcademicAssignmentModal 
                ref="academicAssignmentModal"
                :teacher-id="tab.parent_ui_item.item.id"
                @stored="addAcademicAssignment"
            />
        </div>
    </WeekPlannerPanel>
</template>

<script lang='coffee'>
import AcademicAssignmentModal from '../modals/AcademicAssignmentModal'
import WeekPlannerPanelMixin from '../mixins/week-planner-panel.coffee'
import WeekPlannerAcademicAssignment from '~/ui-classes/WeekPlannerAcademicAssignment'
export default
    name: 'academic-assignments-panel'
    mixins: [WeekPlannerPanelMixin]
    components: {
        AcademicAssignmentModal
    }
    methods:
        showAcademicAssignmentModal: ->
            @$refs.academicAssignmentModal.show = true
        addAcademicAssignment: (item) ->
            @$_addItemToWeekableProperty
                ui_item: new WeekPlannerAcademicAssignment({
                    item
                    parent_ui_item: @tab.parent_ui_item
                })
                data_property: 'academic_assignments'
</script>