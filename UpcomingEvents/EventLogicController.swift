//
//  EventLogicController.swift
//  UpcomingEvents
//
//  Created by Paul Ossenbruggen on 7/7/18.
//  Copyright © 2018 Paul Ossenbruggen. All rights reserved.
//

import UIKit

// swiftlint:disable identifier_name

// Logic controller manages what state the app should be based upon the results
// of the data query.
internal class EventLogicController {
    private let dataLoader: DataLoader
    private let eventProcessor: EventProcessor

    internal enum States {
        case load
        case present([[(Bool, Event)]], [DayInfo])
        case loadFailed(Error)
    }

    internal init(dataLoader: DataLoader, eventProcessor: EventProcessor) {
        self.dataLoader = dataLoader
        self.eventProcessor = eventProcessor
    }

    internal func loadData(completion: @escaping (States) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            DataLoader().load(filename: "mock") { result in
                switch result {
                case .success(let events):
                    let (groupedByDay, dayInfo) = self.eventProcessor.groupByDay(events: events)
                    let eventsOverlaps = self.eventProcessor.checkForOverlaps(events: groupedByDay)
                    completion(.present(eventsOverlaps, dayInfo))
                case .failure(let error):
                    completion(.loadFailed(error))
                }
            }
        }
    }
}
