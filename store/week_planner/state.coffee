import WeekPlannerTab from '~/ui-classes/WeekPlannerTab'

export default ->
    tabs:
        'new-tab': new WeekPlannerTab()
    selected_tab_name: 'new-tab'
    loaded_parent_items: {}
    data:
        teachers: {}
        groups: {}
        subjects: {}
        schedules: {}
        academic_assignments: {}
        availability_teachers: {}
    teachers_by_career: {}