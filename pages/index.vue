<template>
    <div
		class="week-planner-container"
	>
        <div class="text-xs-right">
            <PeriodSelect
                v-model="additional_data.selected_period"
                class="mb-2"
				@input="resetWeekPlanner"
            />
        </div>
		<WeekPlanner
			:additional-data="additional_data"
			ref="weekPlanner"
			:parent-item-id="1"
			:parent-item-ui-class="parent_item_ui_class"
			:initial-request-params="initial_request_params"
		/>
    </div>
</template>

<script lang="coffee">
import PeriodSelect from '~/components/utils/PeriodSelect'
import WeekPlanner from '~/components/week-planner/WeekPlanner'
#import WeekPlannerTeacher from '~/ui-classes/WeekPlannerTeacher'
import WeekPlannerGroup from '~/ui-classes/WeekPlannerGroup'
export default
	name: 'index-item'
	components: {
		PeriodSelect
		WeekPlanner
	}
	data: ->
		additional_data:
			selected_period: @$store.state.current_period
		parent_item_ui_class: WeekPlannerGroup
	methods:
		resetWeekPlanner: ->
			@$refs.weekPlanner.reset()
	computed:
		initial_request_params: ->
			period_id: @additional_data.selected_period.id
</script>