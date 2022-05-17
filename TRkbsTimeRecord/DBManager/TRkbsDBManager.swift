//
//  TRkbsDBManager.swift
//  TRkbsTimeRecord
//
//  Created by JOJO on 2022/5/16.
//

import Foundation
import SQLite
import SwiftyJSON





class TRkbsDBManager: NSObject {
    static let `default` = TRkbsDBManager()
    var db: Connection?
    override init() {
        super.init()
    }
    func prepareDB() {
        do {
            db = try Connection(dbPath())
            createTables()
        } catch {
            debugPrint("prepare database error: \(error)")
        }
    }
    
    fileprivate func dbPath() -> String {
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        let documentPath = documentPaths.first ?? ""
        let dbPath = "\(documentPath)/TimeRecord.sqlite"
        debugPrint("dbPath: \(dbPath)")
        return dbPath
    }
    
    fileprivate func createTables() {
        createHabitBoundTable()
        createDayRecordTable()
    }

}

extension TRkbsDBManager {
    
    func createHabitBoundTable() {
        // 习惯的总信息
        
        let table = Table("HabitBound")
        let habitId = Expression<String>("habitId") // id
        let iconStr = Expression<String>("iconStr")
        let bgColorStr = Expression<String>("bgColorStr")
        let nameStr = Expression<String>("nameStr")
        let timeTypeTagStr = Expression<String>("timeTypeTagStr")
        
        do {
            try db?.run(table.create { t in
                t.column(habitId, primaryKey: true)
                t.column(iconStr)
                t.column(bgColorStr)
                t.column(nameStr)
                t.column(timeTypeTagStr)
            })
        } catch {
            debugPrint("dberror: create table failed. - \("HabitBound")")
        }
    }
    
    func createDayRecordTable() {
        // 每个习惯类别里面 用户单独记录的每一条
        let table = Table("DayRecordList")
        let dayRecordDate = Expression<String>("dayRecordDate")
        let habitId = Expression<String>("habitId")
        let timeCount = Expression<Double>("timeCount")
        let infoStr = Expression<String>("infoStr")
        do {
            try db?.run(table.create { t in
                t.column(dayRecordDate, primaryKey: true)
                t.column(habitId)
                t.column(timeCount)
                t.column(infoStr)
                
            })
        } catch {
            debugPrint("dberror: create table failed. - \("MoneyTagRecordList")")
        }
    }
}

extension TRkbsDBManager {
    func addHabitBound(model: TRkHabitPreviewItem, completionBlock: (()->Void)?) {
        do {
            
            let insetSql = try db?.prepare("INSERT OR REPLACE INTO HabitBound (habitId, iconStr, bgColorStr, nameStr, timeTypeTagStr) VALUES (?,?,?,?,?)")
            let dateStr = CLongLong(round(Date().unixTimestamp*1000)).string
            try insetSql?.run([dateStr ,model.iconStr, model.bgColorStr, model.nameStr, model.timeTypeTagStr])
            completionBlock?()
        } catch {
            debugPrint("error = \(error)")
        }
    }
    
    func updateHabitBound(model: TRkHabitPreviewItem, completionBlock: (()->Void)?) {
        do {
            
            let insetSql = try db?.prepare("REPLACE INTO HabitBound (habitId, iconStr, bgColorStr, nameStr, timeTypeTagStr) VALUES (?,?,?,?,?)")
            
            try insetSql?.run([model.habitId ,model.iconStr, model.bgColorStr, model.nameStr, model.timeTypeTagStr])
            
            completionBlock?()
            
            
        } catch {
            debugPrint("error = \(error)")
        }
    }
    
    func deleteHabitBound(habitId: String, completionBlock: (()->Void)?) {
        let table = Table("HabitBound")
        let db_habitId = Expression<String>("habitId")
        
        let deleteItem = table.filter(db_habitId == habitId)
        
        do {
            try db?.run(deleteItem.delete())
            deleteHabitDayRecordList(habitId: habitId) {
                completionBlock?()
            }
        } catch {
            debugPrint("dberror: delete table failed :\(db_habitId)")
        }
    }
    
    func selectAllHabitBound(completionBlock: (([TRkPreviewBounld])->Void)?) {
        do {
            if let results = try db?.prepare("select * from HabitBound") {
                
                var renyiList: [TRkHabitPreviewItem] = []
                var zaochenList: [TRkHabitPreviewItem] = []
                var zhongwuList: [TRkHabitPreviewItem] = []
                var xiawuList: [TRkHabitPreviewItem] = []
                var wanshangList: [TRkHabitPreviewItem] = []
                var shuiqianList: [TRkHabitPreviewItem] = []
                
                for row in results {
                    
                    let habitId_m = row[0] as? String ?? ""
                    let iconStr_m = row[1] as? String ?? ""
                    let bgColorStr_m = row[2] as? String ?? ""
                    let nameStr_m = row[3] as? String ?? ""
                    let timeTypeTagStr_m = row[4] as? String ?? ""
                    let dayRecordItem = TRkHabitPreviewItem(habitId: habitId_m, iconStr: iconStr_m, bgColorStr: bgColorStr_m, nameStr: nameStr_m, timeTypeTagStr: timeTypeTagStr_m, timeCount: 0)
                    
                    if timeTypeTagStr_m == "任意" {
                        renyiList.append(dayRecordItem)
                    } else if timeTypeTagStr_m == "早晨" {
                        zaochenList.append(dayRecordItem)
                    } else if timeTypeTagStr_m == "中午" {
                        zhongwuList.append(dayRecordItem)
                    } else if timeTypeTagStr_m == "下午" {
                        xiawuList.append(dayRecordItem)
                    } else if timeTypeTagStr_m == "晚上" {
                        wanshangList.append(dayRecordItem)
                    } else if timeTypeTagStr_m == "睡前" {
                        shuiqianList.append(dayRecordItem)
                    }
                }
                
                var bundleList: [TRkPreviewBounld] = []
                
                if renyiList.count != 0 {
                    let bounld = TRkPreviewBounld(timeTypeStr: "任意", previewItems: renyiList)
                    bundleList.append(bounld)
                }
                if zaochenList.count != 0 {
                    let bounld = TRkPreviewBounld(timeTypeStr: "早晨", previewItems: zaochenList)
                    bundleList.append(bounld)
                }
                if zhongwuList.count != 0 {
                    let bounld = TRkPreviewBounld(timeTypeStr: "中午", previewItems: zhongwuList)
                    bundleList.append(bounld)
                }
                if xiawuList.count != 0 {
                    let bounld = TRkPreviewBounld(timeTypeStr: "下午", previewItems: xiawuList)
                    bundleList.append(bounld)
                }
                if wanshangList.count != 0 {
                    let bounld = TRkPreviewBounld(timeTypeStr: "晚上", previewItems: wanshangList)
                    bundleList.append(bounld)
                }
                if shuiqianList.count != 0 {
                    let bounld = TRkPreviewBounld(timeTypeStr: "睡前", previewItems: shuiqianList)
                    bundleList.append(bounld)
                }
                completionBlock?(bundleList)
            }
        } catch {
            debugPrint("dberror: load favorites failed")
        }
        
    }
}
 
    
extension TRkbsDBManager {
    func addHabitDayRecord(model: TRkDayRecordItem, completionBlock: (()->Void)?) {
        do {
            
            let insetSql = try db?.prepare("INSERT OR REPLACE INTO DayRecordList (dayRecordDate, habitId, timeCount, infoStr) VALUES (?,?,?,?)")
            try insetSql?.run([model.recordDate, model.habitId, model.timeCount, model.infoStr])
            completionBlock?()
        } catch {
            debugPrint("error = \(error)")
        }
    }
    
    func deleteHabitDayRecordList(recordDateId: String, completionBlock: (()->Void)?) {
        let table = Table("DayRecordList")
        let db_recordDate = Expression<String>("dayRecordDate")
        
        let deleteItem = table.filter(db_recordDate == recordDateId)
        
        do {
            try db?.run(deleteItem.delete())
        } catch {
            debugPrint("dberror: delete table failed :\(recordDateId)")
        }
    }
    
    func deleteHabitDayRecordList(habitId: String, completionBlock: (()->Void)?) {
        let table = Table("DayRecordList")
        let db_habitId = Expression<String>("habitId")
        
        let deleteItem = table.filter(db_habitId == habitId)
        
        do {
            try db?.run(deleteItem.delete())
            completionBlock?()
        } catch {
            debugPrint("dberror: delete table failed :\(habitId)")
        }
    }
    
    
    
    func selectDayRecordItemList(habitId: String, completionBlock: (([TRkDayRecordItem])->Void)?) {
        do {
            var recordList: [TRkDayRecordItem] = []
            if let results = try db?.prepare("select * from DayRecordList WHERE habitId = '\(habitId)'") {
                for row in results {
                    
                    let recordDate_m = row[0] as? String ?? ""
                    let habitId_m = row[1] as? String ?? ""
                    let timeCount_m = row[2] as? Double ?? 0
                    let infoStr_m = row[3] as? String ?? ""
                    let item = TRkDayRecordItem(recordDate: recordDate_m, habitId: habitId_m, timeCount: timeCount_m, infoStr: infoStr_m)
                    recordList.append(item)
                }
            }
             
            completionBlock?(recordList)
            
        } catch {
            debugPrint("dberror: load favorites failed")
        }
    }
    
    func selectDayRecordItemListTimeCount(habitId: String, completionBlock: ((Double)->Void)?) {
        do {
            var timeCount: Double = 0
            if let results = try db?.prepare("select * from DayRecordList WHERE habitId = '\(habitId)'") {
                for row in results {
                    
                    let _ = row[0] as? String ?? ""
                    let _ = row[1] as? String ?? ""
                    let timeCount_m = row[2] as? Double ?? 0
                    let _ = row[3] as? String ?? ""
                    timeCount += timeCount_m
                }
            }
             
            completionBlock?(timeCount)
            
        } catch {
            debugPrint("dberror: load favorites failed")
        }
    }
    
}








