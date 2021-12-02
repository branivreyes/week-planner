<template>
    <el-popover
        placement="top-end"
        title="Disponibilidad ocupada"
        width="200"
        trigger="hover"
    >

        <i 
            class="ml-1 material-icons md-18 warning--text"
            slot="reference"
        >
            remove_circle
        </i>
    </el-popover>
</template>

<script lang='coffee'>
import WeekPlannerItems from '../mixins/week-planner-items'
export default
    name: 'taken-owned-by'
    mixins: [WeekPlannerItems]
</script>