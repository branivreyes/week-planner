<template>
    <div>
        <span
            class="regular--text small-title"
        >
            Periodo: 
        </span>
        <el-select
            :value="value"
            value-key="id"
            @input="$emit('input', $event)"
            :loading="api$.Period.doing.index"
            loading-text="Cargando periodos..."
        >
            <el-option
                v-for="period in periods_"
                :key="period.id"
                :label="period.description"
                :value="period"
            />
        </el-select>
    </div>

</template>

<script lang='coffee'>
import Period from '~/classes'
export default
    name: 'period-select'
    props:
        periods:
            type: Array
            default: -> []
        value:
            required: true
    data: ->
        periods_: @periods
    created: ->
        if !@periods_.length 
            @api$.Period.index
                no_paginate: true
            .then ({data}) =>
                @periods_ = data
</script>