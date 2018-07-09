//
//  UpcomingEventsTests.swift
//  UpcomingEventsTests
//
//  Created by Paul Ossenbruggen on 7/7/18.
//  Copyright © 2018 Paul Ossenbruggen. All rights reserved.
//

import XCTest
@testable import UpcomingEvents

class UpcomingEventsTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testEventProcessing() {
        let eventProcessor = EventProcessor()
        DataLoader().load(filename: "mock") { results in
            switch results {
            case .success(let events):
                let (grouped, dayInfo) = eventProcessor.groupByDay(events: events)
                let event = grouped.flatMap { $0 }
                _ = event.map { print($0.start) }
                _ = dayInfo.map { print($0.date) }

               _ = eventProcessor.checkForOverlaps(events: grouped)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }

}
