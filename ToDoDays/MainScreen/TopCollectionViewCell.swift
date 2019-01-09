//
//  TopCollectionViewCell.swift
//  ToDoDays
//
//  Created by xvacid on 18/11/2018.
//  Copyright © 2018 WSG4FUN. All rights reserved.
//

import UIKit

class TopCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var dayCaptionLabel: UILabel!
    @IBOutlet private weak var usedTimeLabel: UILabel!
    @IBOutlet private weak var bottomLineView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 4
    }
    
    func configure(_ model: TasksForDayModel?) {
        guard let model      = model else { return }
        usedTimeLabel.text   = "used_time_tasks".localizedFormat(Int(model.usedTaskTime))
        dayCaptionLabel.text = model.day.stringShortDay()
        
        if model.currentDay {
            bottomLineView.backgroundColor = UIColor(r: 255, g: 212, b: 0, a: 255)
        } else {
            bottomLineView.backgroundColor = UIColor(r: 80, g: 227, b: 194, a: 255)
        }
        
        if model.prevDays {
            self.layer.opacity = 0.5
        }
    }
}
