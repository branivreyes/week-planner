<template>
    <el-dialog
        :title="action_title"
        append-to-body
        :visible="visible"
        v-on:update:visible="$emit('update:visible', $event)"
        @open="onOpenModal"
        @close="onCloseModal"
        :before-close="beforeClose"
        v-bind="elementDialogProps"
        :custom-class="'crud-modal' + (customClass ? ' ' + customClass : '')"
    > 
        <template slot="title">
            <slot name="title"></slot>
        </template>
        <el-form
            :rules="formRules"
            :model="form_model"
            ref="form"
            label-position="top"
            v-bind="elementFormProps"
        >
            <slot :form-model="form_model"></slot>
        </el-form>
        <span slot="footer" class="dialog-footer">
            <el-button @click="closeModal">Cancelar</el-button>
            <el-button :loading="destroying" :disabled="destroying" type="danger" v-if="action === 'update'" @click="destroyModel">Eliminar</el-button>
            <el-button :loading="requesting" :disabled="requesting" type="primary" @click="submitForm">{{action_title}}</el-button>
        </span>
    </el-dialog>
</template>

<script lang="coffee">
import * as C from '~/classes'
export default
    name: 'crud-modal'
    props:
        className: String
        modelName: String
        elementDialogProps: Object
        elementFormProps: Object
        visible: Boolean
        model: Object
        formRules: Object
        apiModule: String
        storeParams: Object
        cleanFormAfterAction: Boolean
        dontCloseAfterConfirm: Boolean
        customClass: String
    data: ->
        actions:
            store:
                verb: 'Añadir'
            update:
                verb: 'Editar'
        action: 'store'
        requesting: false
        destroying: false
        form_model: @newItemClass() 
    computed:
        action_title: ->
            @actions[@action].verb + ' ' + @model_name_lower
        model_name_lower: ->
            @modelName.toLowerCase()
    methods:
        areThereChanges: ->
            old_item = JSON.stringify @model
            new_item = JSON.stringify @form_model
            old_item isnt new_item
        newItemClass: ->
            new C[@className]()
        submitForm: ->
            if @areThereChanges()
                @$refs.form.validate (valid) =>
                    if valid
                        @requesting = true
                        @$emit 'before-' + @action, @form_model
                        @$emit 'before-action', @form_model
                        @api$[@className][@action] {...@form_model, ...@storeParams}
                        .then ({ status, error, item, message }) =>
                            @requesting = false
                            if !error
                                @$emit @action + 'd', item
                                if @cleanFormAfterAction
                                    @form_model = @newItemClass()
                                    Object.assign @model, @newItemClass()
                                    @$nextTick =>
                                        @$refs.form.clearValidate()
                                else
                                    Object.assign @model, item
                                    Object.assign @form_model, item
                            @showConfirm message, error
            else
                @$confirm "No hay cambios por guardar.", "Mensaje",
                    confirmButtonText: "Aceptar"
                    showCancelButton: false
                    type: "info"
                .then =>
                .catch =>
        closeModal: ->
            @$emit('update:visible', false)
        onOpenModal: ->
            @action = if @model.id then "update" else "store"
            @$emit('modal-' + @action, @model)
            @$emit('modal-opens', @model, @action)
            @form_model = @$deserialize C[@className], {...@model}
            @$nextTick =>
                @$refs.form.clearValidate()
        onCloseModal: ->
            @form_model = @newItemClass()
            @$nextTick =>
                @$refs.form.clearValidate()
                @$emit 'closed'
        beforeClose: (done) ->
            if @areThereChanges()
                @$confirm "Hay cambios sin guardar. <br> ¿Está seguro que desea cerrar la modal?", "Alerta",
                    confirmButtonText: "Si, cerrar la modal"
                    cancelButtonText: "Cancelar"
                    type: "warning"
                    dangerouslyUseHTMLString: true
                .then ->
                    done()
                .catch ->
            else done()
        destroyModel: ->
            @destroying = true
            @api$[@className].destroy @form_model.id 
            .then ({ status, error, item, message }) =>
                    @destroying = false 
                    Object.assign @model, @newItemClass()
                    @$emit 'destroyed', item
                    @showConfirm message, error
        showConfirm: (message, error) ->
            @$confirm message, "Mensaje",
                confirmButtonText: "Aceptar"
                showCancelButton: false
                type: if error then "error" else "success"
            .then =>
                if !error and !@dontCloseAfterConfirm
                    @closeModal()
            .catch =>
</script>

<style lang="less" src="~/assets/crud-modal.less"></style>