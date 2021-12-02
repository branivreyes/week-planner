export default class WeekableProperties {
    constructor(data) {
        Object.assign(this, data)
    }

    show_in_weektable = true
    _add_hour = () => { return true }
    parent_id_property = ''
    _hoursFilter = () => { return true }
    _itemsFilter = () => { return true }
    label = 'Weekable property'
    panel_component = 'DefaultPanel'

    touched = false

    always_show_in_weektable = 'null'

	get render_in_weektable() {
		if (this.always_show_in_weektable !== 'null')
            return (this.always_show_in_weektable === 'true')
		return this.show_in_weektable
	}
    
    add_hour(state) {
        return this._add_hour(state)
    }
    
    hoursFilter(hour, mode) {
        return this._hoursFilter(hour, mode)
    }

    itemsFilter(item, state) {
        return this._itemsFilter(item, state)
    }
}