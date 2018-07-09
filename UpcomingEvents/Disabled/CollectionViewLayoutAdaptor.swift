//
//  CollectionViewLayoutAdaptor.swift
//  UpcomingEvents
//
//  Created by Paul Ossenbruggen on 7/9/18.
//  Copyright © 2018 Paul Ossenbruggen. All rights reserved.
//

import UIKit

class CollectionEventViewLayoutAdaptor: CollectionViewLayoutAdaptorProtocol {
    var model: [[(Bool, Event)]]

    init() {
        model = []
    }

    func changed(model: [[(Bool, Event)]]) {
        self.model = model
    }

    func collectionView(_ collectionView: UICollectionView,
                        eventAtIndexPath indexPath: IndexPath) -> (Bool, Event) {
        return model[indexPath.section][indexPath.row]
    }
}
