<template>
    <tr
        class="week-planner-header-row"
    >
        <slot></slot>
    </tr>
</template>

<script lang='coffee'>
export default
    name: 'week-planner-header-row'
</script>

<style lang="less">
@import (reference) "../../assets/app.less";
.week-planner-header-row {
    td {
        .pl-5;
        white-space: nowrap;
    }
    td:first-child {
        .pl-0;
    }
    td:last-child {
        width: 100%;
        white-space: inherit;
    }
}
</style>
