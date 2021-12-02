<template>
    <CrudModal
        class-name="AcademicAssignment"
        model-name="actividad"
        :visible.sync="show"
        :model="academic_assignment"
        :form-rules="rules"
        @before-store="beforeStore"
        @stored="$emit('stored', $event)"
        @closed="clearItem"
        custom-class="academic-assignment-modal"
    >
        <template slot-scope="{formModel}">
            <el-form-item
                label="Carrera"
                prop="career_id"
            >
                <el-select
                    v-model="formModel.career_id"
                    filterable
                >
                    <el-option
                        v-for="(career, i) in careers"
                        :label="career.name"
                        :key="i"
                        :value="career.id"
                    />
                </el-select>
            </el-form-item>
            <el-form-item
                label="Actividad"
                prop="type_id"
            >
                <el-select
                    v-model="formModel.type_id"
                    filterable
                >
                    <el-option
                        v-for="(activity, i) in activities"
                        :label="activity.description"
                        :key="i"
                        :value="activity.id"
                    />
                </el-select>
            </el-form-item>
        </template>
    </CrudModal>
</template>

<script lang='coffee'>
import CrudModal from '~/components/resources/CrudModal'
import AcademicAssignment from '~/classes/AcademicAssignment'
export default
    name: 'academic-assignment-modal'
    props:
        teacherId:
            required: true
            type: Number
    inject: [
        'weekPlannerAdditionalData'
    ]
    data: ->
        show: false
        academic_assignment: new AcademicAssignment()
        rules: @$rs
            type_id: ['actividad', { required: true }]
            career_id: ['carrera', { required: true }]
        careers: []
        activities: []
    components: {
        CrudModal
    }
    methods:
        beforeStore: (item) ->
            item.teacher_id = @teacherId
            item.hours = 0
            item.period_id = @weekPlannerAdditionalData.selected_period.id
        clearItem: (item) ->
            @academic_assignment = new AcademicAssignment()
    created: ->
        @api$.Career.index {no_paginate: true}
        .then ({data}) =>
            @careers = data
        @api$.Catalog.index {clasification: @$constants.CLAS_TIPO_CARGA, no_paginate: true}
        .then ({data}) =>
            @activities = data
</script>

<style>
.academic-assignment-modal {
    max-width: 400px;
}
</style>
