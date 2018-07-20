//
//  CollectionViewAdaptor.swift
//  UpcomingEvents
//
//  Created by Paul Ossenbruggen on 7/8/18.
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

// generic adaptor to match model with cells
internal class CollectionViewAdaptor<CollectionCell: UICollectionViewCell, Model>: NSObject,
        UICollectionViewDelegate, UICollectionViewDataSource {
    private var models: [[Model]]
    private let reuseIdentfier: String
    private let configure: (CollectionCell, Model, Int) -> Void
    internal var sectionAdaptor: CollectionViewSectionAdaptor<DayHeader, DayInfo>?
    private let collectionView: UICollectionView

    internal init(
        reuseIdentfier: String,
        collectionView: UICollectionView,
        configure: @escaping (CollectionCell, Model, Int) -> Void
    ) {
        models = []
        self.reuseIdentfier = reuseIdentfier
        self.configure = configure
        self.collectionView = collectionView
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    internal func change(models: [[Model]]) {
        self.models = models
    }

    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return models.count
    }

    internal func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return models[section].count
    }

    internal func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentfier,
            for: indexPath
        ) as? CollectionCell else {
            fatalError("Could not create cell")
        }
        let section = models[indexPath.section]
        let model = section[indexPath.row]
        configure(cell, model, indexPath.row)
        return cell
    }

    internal func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {

        guard let header = sectionAdaptor?.cellForSectionHeader(
            collectionView: collectionView,
            kind: kind,
            indexPath: indexPath
        ) else {
            return UICollectionReusableView()
        }

        return header
    }

    // Quick fix so it redraws the conflict markers when scrolling up, not a perfect fix. 
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionView.reloadData()
    }
}
