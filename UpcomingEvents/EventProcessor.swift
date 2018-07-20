//
//  EventProcessor.swift
//  UpcomingEvents
//
//  Created by Paul Ossenbruggen on 7/7/18.
//  Copyright © 2018 Paul Ossenbruggen. All rights reserved.
//

import Foundation

// Does the processing on the event elements.
internal struct EventProcessor {
    private let formatter = DateFormatter()

    internal init() {
        formatter.dateFormat = "yyyyMMdd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // simpler to deal with
    }

    private func doTimesConflict(event1: Event, event2: Event) -> Bool {
        return event1.start < event2.end && event2.start < event1.end
    }

    // O(N) since sorted. 
    internal func checkForOverlaps(events: [[Event]]) -> [[(Bool, Event)]] {
        return events.map {
            
            var prev = Event(
                title: "",
                start: Date(timeIntervalSince1970: 0),
                end: Date(timeIntervalSince1970: 0))

            return $0.map { event -> (Bool, Event) in
                let overlap = doTimesConflict(event1: prev, event2: event)
                prev = event
                return (overlap, event)
            }
        }
    }

    internal func groupByDay(events: [Event]) -> ([[Event]], [DayInfo]) {

        // strip off detail info from dates, just getting days,
        // keep in tuples so we don't lose pairing.
        let keys = events.map {
            ( formatter.date(from: formatter.string(from: $0.start)) ?? Date(), $0 )
        }

        // sort keys base upon the date O(N log N)
        let sortedKeys = keys.sorted { $0.0 < $1.0 }
        let dict = Dictionary(grouping: sortedKeys) { $0.0 }

        // remove duplicated keys O(N)
        var prev: Date? = nil
        let filteredDups = sortedKeys.filter {
            let result = prev != $0.0
            prev = $0.0
            return result
        }

        // group by day.
        let events: [[Event]] = filteredDups.reduce(into: []) { result, value in
            let items = dict[value.0, default: []].map { $0.1 }
            result += [items]
        }

        // get the day info.
        let dayInfo = filteredDups.map { DayInfo(date: $0.0) }
        return (events, dayInfo)
    }
 }
