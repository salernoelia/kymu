import { type DateValue, toZonedDateTime } from "reka-ui";

/**
 * Converts a JavaScript Date to a DateValue object for use with reka-ui components
 */
export function toDateValue(date: Date): DateValue {
    return toZonedDateTime(date);
}

/**
 * Converts an array of JavaScript Dates to DateValue objects
 */
export function toDateValues(dates: Date[]): DateValue[] {
    return dates.map(toDateValue);
}
