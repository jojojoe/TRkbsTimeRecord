//
//  DataManagerTool.swift
//  TRkbsTimeRecord
//
//  Created by JOJO on 2022/5/9.
//

import Foundation
import SwifterSwift
import NoticeObserveKit

struct TRkIconItem: Codable {
    var thumb: String?
    var big: String?
    var isPro: Bool?
    
}

struct TRkPreviewBounld {
    var timeTypeStr = ""
    var previewItems: [TRkHabitPreviewItem] = []
    
}

struct TRkDayRecordItem {
    var recordDate: String
    var habitId: String = ""
    var timeCount: Double
    var infoStr: String
    
    
}

struct TRkHabitPreviewItem: Codable {
    var habitId: String = ""
    var iconStr: String = ""
    var bgColorStr: String = ""
    var nameStr: String = ""
    var timeTypeTagStr: String = ""
    var timeCount: Double = 0
    
}
extension Notice.Names {
    static let updateHabitList = Notice.Name<Any?>(name: "noti_updateHabitList")
    static let updateDayRecordList = Notice.Name<Any?>(name: "noti_updateDayRecordList")
//    Notice.Center.default.post(name: .pi_noti_coinChange, with: nil)
}

//extension Notification.Name {
//    static let updateHabitList = Notification.Name("noti_updateHabitList")
//    static let updateDayRecordList = Notification.Name("noti_updateDayRecordList")
//}

class DataManagerTool: NSObject {
    static let `default` = DataManagerTool()
    override init() {
        super.init()
    }
    
//    var timeList: [TRkIconItem] {
//        return DataManagerTool.default.loadJson([TRkIconItem].self, name: "iconList") ?? []
//    }
    
    var iconList: [String] = ["swimmer",
                              "guitar",
                              "kiss",
                              "playtime",
                              "laundry-machine",
                              "air-freight",
                              "working 1",
                              "book 1",
                              "coffee",
                              "sleep",
                              "facial-treatment",
                              "farming",
                              "shopping-cart",
                              "hospital-bed",
                              "canvas",
                              "sweep",
                              "watching-a-movie",
                              "baby-bath-tub",
                              "cooking",
                              "bike",
                              "car",
                              "talking",
                              "pet",
                              "writing",
                              "game-console",
                              "sport",
                              "yoga",
                              "walking"]
    
    var colorList: [String] = ["#F2D0B1", "#EDF2B1", "#FCFCFC", "#CEF4FC", "#CEDBFC", "#D7CEFC", "#EDCEFC", "#FCCEDB", "#E6FF83", "#FFE483", "#83C3FF", "#B983FF", "#8388FF", "#FF83DC"]
//    ["任意".localized(), "早晨".localized(), "中午".localized(), "下午".localized(), "晚上".localized(), "睡前".localized()]
    var timeTypeTagList: [String] = ["任意", "早晨", "中午", "下午", "晚上", "睡前"]
    
    var countList: [String] {
        var list: [String] = []
        
        for i in 1...60 {
            list.append("\(i)")
        }
        
        return list
    }
    var minhourList: [String] = ["分钟".localized(), "小时".localized()]
    
}

extension DataManagerTool {
    
    func formatDate(formatStr: String = "MM-dd", date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formatStr
        let str = formatter.string(from: date)
        return str
    }
    
    func convertDateStrToDate(dateStr: String) -> Date {
        let timestamp = dateStr
        let dou = Double(timestamp) ?? 0
        let timeInterStr = String(dou / 1000)
        if let interval = TimeInterval.init(timeInterStr) {
            let recordDate = Date(timeIntervalSince1970: interval)
            return recordDate
        } else {
            return Date()
        }
    }
    
    //  second 秒数
     func formatDate(second: Double) -> String {

       let formatter = DateComponentsFormatter()
        // . dropMiddle为  0d 00h 00m 格式 (需要其它格式可以自己点进去看看)
        formatter.zeroFormattingBehavior = .dropMiddle

      // 此处事例只写了 日 时 分；需要秒的可以在后面加上（参数： | NSCalendar.Unit.second.rawValue ）
        formatter.allowedUnits = NSCalendar.Unit(rawValue: NSCalendar.Unit.day.rawValue | NSCalendar.Unit.hour.rawValue | NSCalendar.Unit.minute.rawValue)

        formatter.unitsStyle = DateComponentsFormatter.UnitsStyle.abbreviated
        
      // 结果默认格式为 1d 1h 1m
        var resultStr = formatter.string(from: TimeInterval(second)) ?? ""

         var tempStr = resultStr.replacingOccurrences(of: "天".localized(), with: " ")
         tempStr = tempStr.replacingOccurrences(of: "小时".localized(), with: " ")
         tempStr = tempStr.replacingOccurrences(of: "分钟".localized(), with: " ")
         var counts = tempStr.components(separatedBy: " ")
         counts = counts.removeAll("")
         if counts.count == 1 {
             resultStr = counts.first! + "分钟".localized()
         } else if counts.count == 2 {
             if counts.last! == "0" {
                 resultStr = counts.first! + "小时".localized()
             } else {
                 resultStr = counts.first! + "小时".localized() + " " + counts.last! + "分钟".localized()
             }
         } else if counts.count == 3 {
             var hStr = ""
             var mStr = ""
             if counts[1] != "0" {
                 hStr = counts[1] + "小时".localized()
             }
             if counts.last! != "0" {
                 mStr = counts.last! + "分钟".localized()
             }
             resultStr = counts.first! + "天".localized() + " " + hStr + " " + mStr
         }
         return resultStr
    }
}

extension DataManagerTool {
    func loadJson<T: Codable>(_: T.Type, name: String, type: String = "json") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                return try! JSONDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                debugPrint(error)
            }
        }
        return nil
    }
    
    func loadJson<T: Codable>(_:T.Type, path:String) -> T? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            do {
                return try PropertyListDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                print(error)
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func loadPlist<T: Codable>(_:T.Type, name:String, type:String = "plist") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            return loadJson(T.self, path: path)
        }
        return nil
    }
}
