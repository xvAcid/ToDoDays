//
//  TaskCell.swift
//  ToDoDays
//
//  Created by xvacid on 21/10/2018.
//  Copyright © 2018 WSG4FUN. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet private weak var coverRoundView: UIView!
    @IBOutlet private weak var buttonFrame: UIView!
    @IBOutlet private weak var buttonLabel: UILabel!
    
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var buttonFrameView: UIView!
    @IBOutlet private weak var progressBgView: UIView!
    @IBOutlet private weak var progressView: UIView!
    @IBOutlet private weak var progressViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var stackView: UIStackView!
    
    private var progressValue: Float = 0.0
    private var section: Int = -1
    private var model: TaskModel?
    private weak var mainScreen: IMainScreenView?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        coverRoundView.layer.cornerRadius = 4
        buttonFrame.layer.cornerRadius    = 10
        buttonFrame.layer.backgroundColor = UIColor.clear.cgColor
        buttonFrame.layer.borderWidth     = 1
        buttonFrame.layer.borderColor     = UIColor.white.cgColor
        buttonLabel.text                  = "start_task_button".localized()
        buttonFrameView.isHidden          = true
        progressValue                     = 0
        
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onPressedEditTask)))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        showProgress()
    }
    
    func configure(taskModel: TaskModel?, mainScreen: IMainScreenView?, section: Int) {
        model        = taskModel
        self.section = section
        if model != nil {
            self.mainScreen       = mainScreen
            captionLabel.text     = "task_time_from_to_text".localizedFormat(model!.startDate.stringTime(), model!.endDate.stringTime())
            descriptionLabel.text = model!.caption
        }
    }
    
    @IBAction func onPressedCloseButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "delete_task_caption".localized(), message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "yes_button".localized(), style: .default, handler: { [weak self] _ in
            guard let `self` = self else { return }
            self.mainScreen?.deleteTask(index: self.model!.index, section: self.section)
        }))

        alertController.addAction(UIAlertAction(title: "no_button".localized(), style: .cancel, handler: nil))
        mainScreen?.presentAlert(alert: alertController)
    }
    
    @IBAction func onPressedStartTask(_ sender: UIButton) {
        print("start task")
    }
    
    @IBAction func onPressedEditTask(_ sender: UIButton) {
        guard model != nil else { return }
        self.mainScreen?.openEditTask(index: self.model!.index, section: self.section)
    }
    
    private func showProgress() {
        coverRoundView.layoutIfNeeded()
        
        if progressValue > 0.0 {
            let value                            = progressValue > 100.0 ? 100.0 : progressValue
            progressView.isHidden                = false
            progressBgView.isHidden              = false
            let stepWidth                        = coverRoundView.bounds.size.width / 100.0
            progressViewWidthConstraint.constant = CGFloat(value) * stepWidth
        } else {
            progressView.isHidden   = true
            progressBgView.isHidden = true
        }
    }
}
