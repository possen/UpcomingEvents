//
//  DataLoader.swift
//  UpcomingEvents
//
//  Created by Paul Ossenbruggen on 7/7/18.
//  Copyright © 2018 Paul Ossenbruggen. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name

internal class DataLoader {

    internal enum Errors: Error {
        case fileNotFound
        case couldNotLoad
    }

    internal enum Result<Data> {
        case success(Data)
        case failure(Error)
    }

    internal func load(filename: String, completion: (Result<[Event]>) -> Void) {
        // assuming this would be from a network rather than a file in real case
        // so making a callback, although using await or something like that might be
        // better.
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            completion(.failure(Errors.fileNotFound))
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy h:mm a"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        do {
            let eventsData = try Data(contentsOf: url)
            let events = try decoder.decode([Event].self, from: eventsData)
            completion(.success(events))
        } catch {
            completion(.failure(Errors.couldNotLoad))
        }
    }
}
