//
//  TaskDayModel.swift
//  ToDoDays
//
//  Created by xvacid on 21/10/2018.
//  Copyright © 2018 WSG4FUN. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class TaskModel: Object {
    @objc dynamic var index: Int          = -1
    @objc dynamic var caption: String     = ""
    @objc dynamic var workMinutes: String = ""
    @objc dynamic var startDate: Date     = Date()
    @objc dynamic var endDate: Date       = Date()
    @objc dynamic var overtimeDate: Date? = nil
    @objc dynamic var isStarted: Bool     = false
    @objc dynamic var isCompleted: Bool   = false
}

class TasksForDayModel: Object {
    @objc dynamic var day: Date            = Date()
    @objc dynamic var usedTaskTime: Double = 0.0
    @objc dynamic var currentDay: Bool     = false
    @objc dynamic var prevDays: Bool       = false
    let tasks                              = List<TaskModel>()
}

class WeekModel: Object {
    @objc dynamic var startWeekDay: Date = Date()
    @objc dynamic var endWeekDay: Date   = Date()

    let days = List<TasksForDayModel>()
}
