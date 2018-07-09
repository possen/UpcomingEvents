//
//  EventCell.swift
//  UpcomingEvents
//
//  Created by Paul Ossenbruggen on 7/7/18.
//  Copyright © 2018 Paul Ossenbruggen. All rights reserved.
//

import UIKit

internal class EventCell: UICollectionViewCell {

    @IBOutlet private weak var startTime: UILabel!
    @IBOutlet private weak var endTime: UILabel!
    @IBOutlet private weak var eventTitle: UILabel!
    @IBOutlet private weak var conflict: UIImageView!

    static private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        return dateFormatter
    }()

    internal struct ViewData {
        let index: Int
        let model: (Bool, Event)
    }

    // when data gets set by config call the UI elements are updated.
    internal var viewData: ViewData? {
        didSet {
            guard let viewData = viewData else {
                return
            }
            let format = EventCell.dateFormatter
            let (overlapped, model) = viewData.model
            startTime.text = format.string(from: model.start)
            endTime.text = format.string(from: model.end)
            eventTitle.text = model.title
            conflict.isHidden = !overlapped
        }
    }
}

extension EventCell.ViewData {
    internal init(model: (Bool, Event), index: Int) {
        self.model = model
        self.index = index
    }
}
