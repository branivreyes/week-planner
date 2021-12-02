export default class WeekPlannerParentItem {
	
	static weekable_classes = {}
	static item_class = null

	constructor(data) {
		Object.assign(this, data)
	}
	item = undefined
    prior_weekable_property = ''
	weekable_properties = {}
	weekable_child_foreign_id = ''
	category_data = {}

	show_weekable_data = true
	always_show_weekable_data = null

	header_component = 'DefaultHeader'
	tools_component = ''

	weekable_properties_touched = false

	get render_weekable_data() {
		if (this.always_show_weekable_data !== null)
			return this.always_show_weekable_data
		return this.show_weekable_data
	}

	get item_category() {
		return this.item ? this.item.constructor.api_path : ''
	}

	get tab_label() {
		return 'TAB NAME'
	}

	get key() {
		return this.item ? this.item_category + this.item.id : ''
	}

	createUiItems(week_planner_data) {

		let ui_items = {}

		ui_items[this.item_category] = {
			[this.item.id]: this
		}

		for (const property in this.weekable_properties) {

			let node = {}
			let ui_class = this.constructor.weekable_classes[property]

			for (const id in this.item[property]) {

				let item = week_planner_data[property][id]

				node[id] = new ui_class({ item, parent_ui_item: this })
			}

			ui_items[property] = node
		}

		return ui_items
	}
}
