//
//  Event.swift
//  UpcomingEvents
//
//  Created by Paul Ossenbruggen on 7/7/18.
//  Copyright © 2018 Paul Ossenbruggen. All rights reserved.
//

import Foundation

internal struct Event: Decodable {
    internal let title: String
    internal let start: Date
    internal let end: Date
}
