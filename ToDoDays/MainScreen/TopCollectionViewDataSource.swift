//
//  TopCollectionViewDataSource.swift
//  ToDoDays
//
//  Created by xvacid on 18/11/2018.
//  Copyright © 2018 WSG4FUN. All rights reserved.
//

import UIKit

class TopCollectionViewDataSource: NSObject {
    fileprivate var todoDaysWorker: ToDoDaysWorker?
    fileprivate weak var collectionView: UICollectionView?
    
    var currentWeekDay: Int {
        return todoDaysWorker?.currentDay ?? -1
    }
    
    func setup(_ todoDaysWorker: ToDoDaysWorker, collectionView: UICollectionView) {
        self.todoDaysWorker = todoDaysWorker
        self.collectionView = collectionView
        scrollToItemAfterReload()
    }
    
    private func scrollToItemAfterReload() {
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            let currentDay = Date().getCurrentWeekDay()
            let indexPath  = IndexPath(row: currentDay < 2 ? currentDay : currentDay - 2, section: 0)
            self?.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
        
        self.collectionView?.reloadData()
        CATransaction.commit()
    }
}

extension TopCollectionViewDataSource: UICollectionViewDelegate {
}

extension TopCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todoDaysWorker?.getDaysCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCollectionViewCell", for: indexPath) as? TopCollectionViewCell
        let model = todoDaysWorker?.getDayModel(indexPath.row)
        cell?.configure(model)
        return cell!
    }
    
}
