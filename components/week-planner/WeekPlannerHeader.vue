<template>
    <div class="week-planner-header">
        <table
            class="header-table"
        >
            <slot></slot>
        </table>
    </div>
</template>

<script lang='coffee'>
export default
    name: 'week-planner-header'
</script>

<style lang="less">
@import (reference) "../../assets/app.less";
.week-planner-header {
    .pa-2;
    .header-table {
        width: 100%;
        border-collapse: collapse;
    }
}
</style>
