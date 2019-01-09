//
//  AddTaskViewController.swift
//  ToDoDays
//
//  Created by xvacid on 29/11/2018.
//  Copyright © 2018 WSG4FUN. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var coverView: UIView!
    @IBOutlet private weak var newTaskCaption: UILabel!
    @IBOutlet private weak var taskNameView: UIView!
    @IBOutlet private weak var taskNameTextField: UITextField!
    @IBOutlet private weak var startTaskLabel: UILabel!
    @IBOutlet private weak var startTaskDataPicker: UIDatePicker!
    @IBOutlet private weak var endTaskLabel: UILabel!
    @IBOutlet private weak var endTaskDataPicker: UIDatePicker!
    @IBOutlet private weak var createButton: UIButton!
    private var todoDaysWorker: ToDoDaysWorker?
    private var mainScreenView: IMainScreenView?
    
    private let timeOffset: TimeInterval = 5.0 * 60.0
    private var selectedDay: Int         = -1
    private var index: Int               = -1
    private var section: Int             = -1
    private let durationAppear: Double   = 0.5

    override func viewDidLoad() {
        super.viewDidLoad()

        let dissmisWindowGesture      = UITapGestureRecognizer(target: self, action: #selector(dismissWindow))
        let closeKeyboardGesture      = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        dissmisWindowGesture.delegate = self
        mainView.addGestureRecognizer(dissmisWindowGesture)
        coverView.addGestureRecognizer(closeKeyboardGesture)
        
        coverView.layer.cornerRadius       = 4
        coverView.clipsToBounds            = true
        createButton.layer.cornerRadius    = 4
        taskNameView.layer.cornerRadius    = 4
        newTaskCaption.text                = "new_task_caption".localized()
        startTaskLabel.text                = "start_task_text".localized()
        endTaskLabel.text                  = "end_task_text".localized()
        startTaskDataPicker.minuteInterval = Int(timeOffset)
        endTaskDataPicker.minuteInterval   = Int(timeOffset)
        startTaskDataPicker.date           = Date()
        endTaskDataPicker.date             = Date(timeInterval: timeOffset, since: Date())
        startTaskDataPicker.date           = Date.round(date: startTaskDataPicker.date, for: startTaskDataPicker.minuteInterval)
        endTaskDataPicker.date             = Date.round(date: endTaskDataPicker.date, for: endTaskDataPicker.minuteInterval)

        createButton.setTitle("add_task_button".localized(), for: .normal)
        
        let textFieldColor = UIColor(r: 157, g: 157, b: 157, a: 255)
        taskNameTextField.attributedPlaceholder = NSAttributedString(string: "task_name_caption_placeholder".localized(),
                                                                     attributes: [NSAttributedString.Key.foregroundColor: textFieldColor])
        
        let dataPickerColor = UIColor(r: 234, g: 236, b: 238, a: 255)
        startTaskDataPicker.setValue(dataPickerColor, forKeyPath: "textColor")
        startTaskDataPicker.setValue(false, forKeyPath: "highlightsToday")

        endTaskDataPicker.setValue(dataPickerColor, forKeyPath: "textColor")
        endTaskDataPicker.setValue(false, forKeyPath: "highlightsToday")
        
        guard index != -1,
            let task = todoDaysWorker?.getTaskModel(index) else { return }
        taskNameTextField.text   = task.caption
        startTaskDataPicker.date = task.startDate
        endTaskDataPicker.date   = task.endDate
        createButton.setTitle("update_task_button".localized(), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showAnimateCoverView()
        showAnimateButton()
    }
    
    public func configure(container: GroupContainer) {
        todoDaysWorker = container.get() ?? nil
        selectedDay    = container.get() ?? -1
        mainScreenView = container.get() ?? nil
        index          = container.get("index") ?? -1
        section        = container.get("section") ?? -1
    }
    
    @IBAction func onPressedAddTask(_ sender: UIButton) {
        guard let text = taskNameTextField.text else { return }
        if !text.isEmpty {
            if todoDaysWorker?.canAddTaskForDates(day: selectedDay, startDate: startTaskDataPicker.date, endDate: endTaskDataPicker.date) == true {
                dismissWindow()
                
                if index == -1 {
                    todoDaysWorker?.addTask(day: selectedDay, caption: text, startDate: startTaskDataPicker.date, endDate: endTaskDataPicker.date)
                    mainScreenView?.reloadTaskTableView()
                } else {
                    todoDaysWorker?.updateTask(day: selectedDay, index: index, caption: text,
                                               startDate: startTaskDataPicker.date, endDate: endTaskDataPicker.date)
                    mainScreenView?.reloadTaskTableView()
                }
            } else {
                let alert = UIAlertController(title: "add_task_wrong_date".localized(), message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok_button".localized(), style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "add_task_empty_caption".localized(), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok_button".localized(), style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func dismissWindow() {
        hideAnimateCoverView()
        hideAnimateButton()
    }
    
    @objc private func closeKeyboard() {
        taskNameTextField.resignFirstResponder()
    }
    
    @IBAction func onStartDateValueChanged(_ sender: Any) {
        closeKeyboard()
        
        if Int(startTaskDataPicker.date.timeIntervalSince1970) >= Int(endTaskDataPicker.date.timeIntervalSince1970) {
            endTaskDataPicker.date = Date(timeInterval: timeOffset, since: startTaskDataPicker.date)
        }
    }
    
    @IBAction func OnEndDateValueChanged(_ sender: Any) {
        closeKeyboard()
        
        if Int(endTaskDataPicker.date.timeIntervalSince1970) <= Int(startTaskDataPicker.date.timeIntervalSince1970) {
            startTaskDataPicker.date = Date(timeInterval: -timeOffset, since: endTaskDataPicker.date)
        }
    }
    
    // MARK: - Animations
    private func showAnimateCoverView() {
        coverView.transform = CGAffineTransform(translationX: 0, y: coverView.frame.size.height).scaledBy(x: 0.9, y: 0.9)
        UIView.animate(withDuration: durationAppear, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 3,
                       options: UIView.AnimationOptions.curveEaseIn, animations: {
                        self.coverView.transform = CGAffineTransform(translationX: 0.0, y: 0.0).scaledBy(x: 1.0, y: 1.0)
        }, completion: nil)
    }
    
    private func hideAnimateCoverView() {
        coverView.transform = CGAffineTransform(translationX: 0.0, y: 0.0).scaledBy(x: 1.0, y: 1.0)
        UIView.animate(withDuration: durationAppear, delay: 0.1, animations: {
            self.coverView.transform = CGAffineTransform(translationX: 0, y: self.coverView.frame.size.height * 1.5)
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + durationAppear * 0.5, execute: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        })
    }
    
    private func showAnimateButton() {
        createButton.transform = CGAffineTransform(translationX: 0, y: createButton.frame.size.height * 2.0).scaledBy(x: 0.9, y: 0.9)
        UIView.animate(withDuration: durationAppear, delay: 0.1, usingSpringWithDamping: 0.75, initialSpringVelocity: 3,
                       options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.createButton.transform = CGAffineTransform(translationX: 0.0, y: 0.0).scaledBy(x: 1.0, y: 1.0)
        }, completion: nil)
    }
    
    private func hideAnimateButton() {
        createButton.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
        UIView.animate(withDuration: durationAppear, delay: 0.0, animations: {
            self.createButton.transform = CGAffineTransform(translationX: 0, y: self.createButton.frame.size.height * 2.0)
        }, completion: nil)
    }
}

extension AddTaskViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == mainView {
            return true
        }
        return false
    }
}
