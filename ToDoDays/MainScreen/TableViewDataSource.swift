//
//  TableViewDataSource.swift
//  ToDoDays
//
//  Created by xvacid on 24/10/2018.
//  Copyright © 2018 WSG4FUN. All rights reserved.
//

import UIKit

class TableViewDataSource: NSObject {
    private var todoDaysWorker: ToDoDaysWorker?
    private weak var mainScreen: IMainScreenView?
    
    func setup(_ todoDaysWorker: ToDoDaysWorker, mainScreen: IMainScreenView?) {
        self.todoDaysWorker = todoDaysWorker
        self.mainScreen     = mainScreen
    }
}

extension TableViewDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = tableView.backgroundColor
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = tableView.backgroundColor
    }
}

extension TableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return todoDaysWorker?.getTasksCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as? TaskCell
        cell?.configure(taskModel: todoDaysWorker?.getTaskModel(indexPath.section), mainScreen: mainScreen, section: indexPath.section)
        return cell!
    }
    
}
