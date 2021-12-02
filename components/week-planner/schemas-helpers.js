import {
  custom,
  deserialize
} from "serializr";

import * as C from "~/classes";

export const mapDays = () => {
    return custom(
        v => v,
        days => {
        if (days.constructor === Array)
            return deserialize(C.Day, days)
        else 
            return days
        }
    )
}

export const mapWeekableProperty = (_class) => {
    return custom(
        v => v,
        items => {
            if (items.constructor === Array) return deserialize(_class, items)
            else return items
        }
  )
}