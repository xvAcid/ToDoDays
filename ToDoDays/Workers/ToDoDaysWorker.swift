//
//  ToDoDaysWorker.swift
//  ToDoDays
//
//  Created by xvacid on 19/11/2018.
//  Copyright © 2018 WSG4FUN. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class ToDoDaysWorker: NSObject {
    private let daysCount: Int  = 7
    private(set) var currentDay: Int = -1
    private var model: WeekModel?
    
    override init() {
        super.init()
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(realm.objects(WeekModel.self))
            }

            model = realm.objects(WeekModel.self).first
            
            if model == nil {
                fillEmptyDays(realm: realm)
            }
        } catch let error {
            print("-- ToDo days worker error \(error.localizedDescription)")
        }
    }
    
    func addTask(day: Int, caption: String, startDate: Date, endDate: Date) {
        do {
            let realm         = try Realm()
            let week          = realm.objects(WeekModel.self).first
            guard let weekDay = week?.days[day] else { return }
            
            try realm.write {
                let task         = TaskModel()
                task.index       = weekDay.tasks.count
                task.caption     = caption
                task.workMinutes = "\(Int((endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970) / 60.0))"
                task.isCompleted = false
                task.isStarted   = false
                task.startDate   = startDate
                task.endDate     = endDate
                weekDay.tasks.append(task)
            }
        } catch let error {
            print("-- ToDo days worker error \(error.localizedDescription)")
        }
    }
    
    func updateTask(day: Int, index: Int, caption: String, startDate: Date, endDate: Date) {
        do {
            let realm         = try Realm()
            let week          = realm.objects(WeekModel.self).first
            guard let weekDay = week?.days[day] else { return }
            
            try realm.write {
                guard let task   = weekDay.tasks.filter("index == \(index)").first else { return }
                task.caption     = caption
                task.workMinutes = "\(Int((endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970) / 60.0))"
                task.isCompleted = false
                task.isStarted   = false
                task.startDate   = startDate
                task.endDate     = endDate
            }
        } catch let error {
            print("-- ToDo days worker error \(error.localizedDescription)")
        }
    }
    
    func removeTask(day: Int, index: Int) {
        do {
            let realm = try Realm()
            let week  = realm.objects(WeekModel.self).first
            guard let weekDay = week?.days[day] else { return }
            
            try realm.write {
                guard let task = weekDay.tasks.filter("index == \(index)").first else { return }
                realm.delete(task)
            }
        } catch let error {
            print("-- ToDo days worker error \(error.localizedDescription)")
        }
    }
    
    func canAddTaskForDates(day: Int, startDate: Date, endDate: Date) -> Bool {
        do {
            let realm = try Realm()
            let week  = realm.objects(WeekModel.self).first
            guard let weekDay = week?.days[day] else { return false }
            
            for task in weekDay.tasks {
                if startDate.checkIntersect(start: task.startDate, end: task.endDate)
                    || endDate.checkIntersect(start: task.startDate, end: task.endDate) {
                    return false
                }
            }
        } catch let error {
            print("-- ToDo days worker error \(error.localizedDescription)")
        }
        
        return true
    }
    
    func recalculateAssignedTimes(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let realm = try Realm()
                let weeks = realm.objects(WeekModel.self)
                try realm.write {
                    for week in weeks {
                        for day in week.days {
                            var usedTimes = 0.0
                            for task in day.tasks {
                                usedTimes += task.endDate.timeIntervalSince1970 - task.startDate.timeIntervalSince1970
                            }
                            
                            day.usedTaskTime = usedTimes / 3600.0
                        }
                    }
                }
                
                DispatchQueue.main.async { completion() }
            } catch let error {
                print("-- ToDo days worker error \(error.localizedDescription)")
                DispatchQueue.main.async { completion() }
            }
        }
    }
    
    func getDaysCount() -> Int {
        return model?.days.count ?? 0
    }
    
    func getDayModel(_ index: Int) -> TasksForDayModel? {
        return model?.days[index]
    }
    
    func getTasksCount() -> Int {
        return model?.days[currentDay].tasks.count ?? 0
    }
    
    func getTaskModel(_ index: Int) -> TaskModel? {
        return model?.days[currentDay].tasks[index]
    }
    
    private func fillEmptyDays(realm: Realm) {
        do {
            try realm.write {
                model = WeekModel()
                model!.startWeekDay = Date().next(2)
                
                for day in 0..<7 {
                    let tasks        = TasksForDayModel()
                    tasks.day        = Date(timeInterval: TimeInterval(day * 86400), since: model!.startWeekDay)
                    tasks.currentDay = Date().stringDayMonthAndYear() == tasks.day.stringDayMonthAndYear()
                    tasks.prevDays   = true
                    model!.days.append(tasks)
                    
                    if tasks.currentDay {
                        currentDay     = day
                        tasks.prevDays = false
                    } else if currentDay != -1 {
                        tasks.prevDays = day < currentDay
                    }
                    
                    if day == 6 {
                        model!.endWeekDay = tasks.day
                    }
                }
                
                realm.add(model!)
            }
        } catch let error {
            print("-- ToDo days worker error \(error.localizedDescription)")
        }
    }
}
