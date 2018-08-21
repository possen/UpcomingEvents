//
//  CollectionViewHeaderAdaptor.swift
//  UpcomingEvents
//
//  Created by Paul Ossenbruggen on 8/4/18.
//  Copyright © 2018 Paul Ossenbruggen. All rights reserved.
//
import UIKit

protocol CollectionViewSectionAdaptorProtocol {
    associatedtype HeaderCellType
    associatedtype ModelType
}

// generic section adaptor to match model with header cell
internal class CollectionViewSectionAdaptor<HeaderCell: UICollectionReusableView, Model>:
NSObject, CollectionViewSectionAdaptorProtocol {
    typealias HeaderCellType = HeaderCell
    typealias ModelType = Model
    private let reuseIdentfier: String
    private let configure: (HeaderCell, Model) -> Void
    private var models: [Model]

    internal init(
        reuseIdentfier: String,
        collectionView: UICollectionView,
        configure: @escaping (HeaderCell, Model) -> Void
        ) {
        self.reuseIdentfier = reuseIdentfier
        self.configure = configure
        self.models = []
    }

    internal func change( sections: [Model]) {
        self.models = sections
    }

    internal func cellForSectionHeader(
        collectionView: UICollectionView,
        kind: String,
        indexPath: IndexPath
        ) -> HeaderCell {

        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "DayHeader",
            for: indexPath
            ) as? HeaderCell else {
                fatalError("Could not create cell")
        }

        let model = models[indexPath.section]
        configure(header, model)
        return header
    }
}
