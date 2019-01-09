//
//  MainScreenView.swift
//  ToDoDays
//
//  Created by xvacid on 12/10/2018.
//  Copyright © 2018 WSG4FUN. All rights reserved.
//

import UIKit

protocol IMainScreenView: class {
    func reloadTaskTableView()
    
    func deleteTask(index: Int, section: Int)
    func openEditTask(index: Int, section: Int)
    func presentAlert(alert: UIAlertController)
}

class MainScreenView: UIViewController {
    @IBOutlet private weak var frameCollectionView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addTaskButton: UIButton!
    @IBOutlet private weak var tableDataSource: TableViewDataSource!
    @IBOutlet private weak var topDataSource: TopCollectionViewDataSource!
    private let todoDaysWorker: ToDoDaysWorker = ToDoDaysWorker()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()
        frameCollectionView.layer.cornerRadius  = 4
        frameCollectionView.layer.borderWidth   = 1
        frameCollectionView.layer.borderColor   = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2).cgColor
        
        tableView.register(UINib(nibName: "TaskCell", bundle: Bundle.main), forCellReuseIdentifier: "TaskCell")
        collectionView.register(UINib(nibName: "TopCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "TopCollectionViewCell")
        
        tableDataSource.setup(todoDaysWorker, mainScreen: self)
        topDataSource.setup(todoDaysWorker, collectionView: collectionView)
    }
    
    @IBAction func onPressedAddTask(_ sender: UIButton) {
        addTaskButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        UIView.animate(withDuration: 0.05, animations: { [weak self] in
            self?.addTaskButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { [weak self] _ in
            UIView.animate(withDuration: 0.1, animations: {
                self?.addTaskButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        }
        
        guard let vc = UIStoryboard(name: "AddTaskViewController", bundle: Bundle.main)
            .instantiateInitialViewController() as? AddTaskViewController else { return }
        
        let container = GroupContainer()
        container.add(todoDaysWorker)
        container.add(topDataSource.currentWeekDay)
        container.add(self as IMainScreenView)
        vc.configure(container: container)
        
        present(vc, animated: true, completion: nil)
    }
}

extension MainScreenView: IMainScreenView {
    func reloadTaskTableView() {
        todoDaysWorker.recalculateAssignedTimes { [weak self] in
            self?.collectionView.reloadData()
        }
        
        tableView.reloadData()
    }
    
    func deleteTask(index: Int, section: Int) {
        todoDaysWorker.removeTask(day: todoDaysWorker.currentDay, index: index)
        todoDaysWorker.recalculateAssignedTimes { [weak self] in
            self?.collectionView.reloadData()
        }

        tableView.deleteSections([section], with: .automatic)
        
        var sections: IndexSet = IndexSet()
        for index in 0..<tableView.numberOfSections {
            sections.insert(index)
        }
        
        tableView.reloadSections(sections, with: .none)
    }
    
    func openEditTask(index: Int, section: Int) {
        guard let vc = UIStoryboard(name: "AddTaskViewController", bundle: Bundle.main)
            .instantiateInitialViewController() as? AddTaskViewController else { return }
        
        let container = GroupContainer()
        container.add(todoDaysWorker)
        container.add(topDataSource.currentWeekDay)
        container.add(self as IMainScreenView)
        container.add(index, "index")
        container.add(section, "section")
        vc.configure(container: container)
        
        present(vc, animated: true, completion: nil)
    }
    
    func presentAlert(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}
