//
//  DayHeader.swift
//  UpcomingEvents
//
//  Created by Paul Ossenbruggen on 7/8/18.
//  Copyright © 2018 Paul Ossenbruggen. All rights reserved.
//

import UIKit

class DayHeader: UICollectionReusableView {
    @IBOutlet weak var title: UILabel!

    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d • EEEE" //should use locale info.
        return dateFormatter
    }()

    internal struct ViewData {
        let model: DayInfo
    }

    internal var viewData: ViewData? {
        didSet {
            guard let viewData = viewData else {
                return
            }
            let format = DayHeader.dateFormatter
            let model = viewData.model
            title.text = format.string(from: model.date)
        }
    }
}
