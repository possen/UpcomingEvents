//
//  EventViewController.swift
//  UpcomingEvents
//
//  Created by Paul Ossenbruggen on 7/7/18.
//  Copyright © 2018 Paul Ossenbruggen. All rights reserved.
//

import UIKit

internal class EventViewController: UICollectionViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!

    private lazy var lvars: LazyLoaded = {
        return LazyLoaded(
            parent: self,
            logicController: EventLogicController(
                dataLoader: DataLoader(),
                eventProcessor: EventProcessor()
            )
        )
    }()

    // These variables can not be accessed until view is loaded, so enforce that
    // by creating a separate struct
    private struct LazyLoaded {
        internal let adaptor: CollectionViewAdaptor<EventCell, (Bool, Event)>
        internal let sectionAdaptor: CollectionViewSectionAdaptor<DayHeader, DayInfo>
        internal let logicController: EventLogicController

        internal init(parent: EventViewController, logicController: EventLogicController) {
            self.logicController = logicController

            // Setup Collection adaptor, alternating color cells.
            self.adaptor = CollectionViewAdaptor(
                reuseIdentfier: String(describing: EventCell.self),
                collectionView: parent.collectionView
            ) { cell, model, index in

                // pair the cell with the data model
                cell.viewData = EventCell.ViewData(model: model, index: index)

                cell.backgroundColor = index % 2 == 1
                    ? UIColor.init(red: 0xDF/255.0, green: 0xEB/255.0, blue: 0xFF/255.0, alpha: 0.5)
                    : UIColor.init(red: 0xD0/255.0, green: 0xEB/255.0, blue: 0xFF/255.0, alpha: 0.5)
            }

            // Setup section adaptor to display the DayInfo.
            self.sectionAdaptor = CollectionViewSectionAdaptor(
                reuseIdentfier: String(describing: DayInfo.self),
                collectionView: parent.collectionView
            ) { cell, model in
                cell.viewData = DayHeader.ViewData(model: model)
            }
            self.adaptor.sectionAdaptor = self.sectionAdaptor
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func loadData() {
        // While data loads display spinner.
        update(state: .load)

        // Error or success update
        lvars.logicController.loadData { [weak self] state in
            DispatchQueue.main.async {
                self?.update(state: state)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
}

internal extension EventViewController {

    internal func update(state: EventLogicController.States) {
        switch state {
        case .load:
            spinner.isHidden = false

        case .present(let events, let dayInfo):
            spinner.isHidden = true
            lvars.adaptor.change(models: events)
            lvars.sectionAdaptor.change(sections: dayInfo)
            collectionView.reloadData()

        case .loadFailed(let error):
            spinner.isHidden = true
            let alert = UIAlertController(
                title: "Error",
                message: error.localizedDescription,
                preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default) { action in
                alert.dismiss(animated: true)
            }
            alert.addAction(okButton)
            present(alert, animated: true)
        }
    }
}
