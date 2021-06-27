//
//  DetailCollectionDataProvider copy.swift
//  Weather_MVVM
//
//  Created by Ara Hakobyan on 06.03.21.
//  Copyright © 2020 AroHak. All rights reserved.
//

import UIKit

public class CollectionDataProvider<View: ContainerView, Cell: CollectionViewCell<View>>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    struct Settings {
    }
    
    public var didSelect: ((View.Model) -> Void)?
    private var settings: Settings!
    private weak var collectionView: UICollectionView!
    private var models = [View.Model]()

    init(with settings: Settings = .init(), collectionView: UICollectionView) {
        super.init()
        self.settings = settings
        self.collectionView = collectionView
        config()
    }
    
    private func config() {
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.registerCell(Cell.self)
    }
    
    public func update(with models: [View.Model]) {
        self.models = models
        collectionView?.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(indexPath) as Cell
        let model = models[indexPath.row]
        cell.model = model
        return cell
    }
}
