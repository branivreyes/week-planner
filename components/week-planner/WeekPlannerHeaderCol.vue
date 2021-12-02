<template>
    <td
        :colspan="colspan"
    >
        <div class="header-col">
            <i class="material-icons md-18">{{icon}}</i>
            <div>
                <slot>
                    <b>{{label}}:</b> {{value}}
                </slot>
            </div>
        </div>
    </td>
</template>

<script lang='coffee'>
export default
    name: 'week-planner-header-col'
    props:
        label:
            type: String
            default: 'Label'
        value:
            type: String
            default: 'Value'
        colspan:
            type: Number
            default: 1
        icon:
            type: String
            default: 'home'
</script>

<style lang="less">
@import (reference) "../../assets/app.less";
.header-col {
    display: flex;
    align-items: center;
    .regular--text;
    .body;
    i {
        .mr-1;
    }
}
</style>
