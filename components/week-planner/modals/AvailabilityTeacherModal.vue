<template>
    <CrudModal
       class-name="AvailabilityTeacher"
       model-name="disponibilidad"
       :visible.sync="show"
       :model="availability_teacher"
       :form-rules="rules"
       custom-class="availability-teacher-modal"
       @before-store="beforeStore"
       @stored="stored"
       @closed="clearItem"
    >
       <template slot-scope="{formModel}">
            <el-form-item 
                prop="career_id"
                label="Carrera"
            >
                <el-select
                    v-model="formModel.career_id"
                    placeholder="Seleccione"
                    filterable
                >
                    <el-option 
                        v-for="(career, i) in careers"
                        :key="i"
                        :label="career.name"
                        :value="career.id"
                    />
                </el-select>
            </el-form-item>
       </template>
    </CrudModal>
</template>

<script lang="coffee">
import CrudModal from '~/components/resources/CrudModal'
import AvailabilityTeacher from '~/classes/AvailabilityTeacher'
export default
    name: 'availability-teacher-modal'
    props:
        teacherId: null
    components: {
        CrudModal
    }
    inject: [
        'weekPlannerAdditionalData'
    ]
    data: ->
        show: false
        availability_teacher: new AvailabilityTeacher()
        rules: @$rs
            career_id: ['carrera', { required: true }]
        careers: []
    methods:
        beforeStore: (availability_teacher) ->
            Object.assign availability_teacher,
                teacher_id: @teacherId
                period_id: @weekPlannerAdditionalData.selected_period.id
        stored: (availability_teacher) ->
            @$emit 'stored', availability_teacher
        clearItem: ->
            @availability_teacher = new AvailabilityTeacher()
    created: ->
        @api$.Career.index {no_paginate: true}
        .then ({data}) =>
            @careers = data
</script>

<style>
.availability-teacher-modal {
    max-width: 400px;
}
</style>