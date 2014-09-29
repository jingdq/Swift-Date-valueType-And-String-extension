//
//  Date.swift
//
//  Created by bujiandi(慧趣小歪) on 14/9/26.
//
//  值类型的 Date 使用方便 而且避免使用 @NSCopying 的麻烦
//  基本遵循了官方所有关于值类型的实用协议 放心使用
//

import Foundation

func ==(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeInterval == rhs.timeInterval
}
func <=(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeInterval <= rhs.timeInterval
}
func >=(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeInterval >= rhs.timeInterval
}
func >(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeInterval > rhs.timeInterval
}
func <(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeInterval < rhs.timeInterval
}
func +(lhs: Date, rhs: NSTimeInterval) -> Date {
    return Date(rhs, sinceDate:lhs)
}
func -(lhs: Date, rhs: NSTimeInterval) -> Date {
    return Date(-rhs, sinceDate:lhs)
}
func +(lhs: NSTimeInterval, rhs: Date) -> Date {
    return Date(lhs, sinceDate:rhs)
}
func -(lhs: NSTimeInterval, rhs: Date) -> Date {
    return Date(-lhs, sinceDate:rhs)
}

func +=(inout lhs: Date, rhs: NSTimeInterval) {
    return lhs = Date(rhs, sinceDate:lhs)
}
func -=(inout lhs: Date, rhs: NSTimeInterval) {
    return lhs = Date(-rhs, sinceDate:lhs)
}


struct Date {
    var timeInterval:NSTimeInterval = 0
    
    init() { self.timeInterval = NSDate().timeIntervalSince1970 }
}

extension Date {
    var timeIntervalSinceReferenceDate: NSTimeInterval {
        return NSDate(timeIntervalSince1970: timeInterval).timeIntervalSinceReferenceDate
    }
    var timeIntervalSinceNow: NSTimeInterval {
        return NSDate(timeIntervalSince1970: timeInterval).timeIntervalSinceNow
    }
    var timeIntervalSince1970: NSTimeInterval { return timeInterval }


}

// MARK: - 输出
extension Date {
    func stringWithFormat(_ format:String = "yyyy-MM-dd HH:mm:ss") -> String {
        var formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(NSDate(timeIntervalSince1970: timeInterval))
    }
}

// MARK: - 计算
extension Date {
    mutating func addDay(day:Int) {
        timeInterval += Double(day) * 24 * 3600
    }
    mutating func addHour(hour:Int) {
        timeInterval += Double(hour) * 3600
    }
    mutating func addMinute(minute:Int) {
        timeInterval += Double(minute) * 60
    }
    mutating func addSecond(second:Int) {
        timeInterval += Double(second)
    }
    mutating func addMonth(month m:Int) {
        let (year, month, day) = getDay()
        let (hour, minute, second) = getTime()
        let era = year / 100
        if let date = NSCalendar.currentCalendar().dateWithEra(era, year: year, month: month + m, day: day, hour: hour, minute: minute, second: second, nanosecond: 0) {
            timeInterval = date.timeIntervalSince1970
        } else {
            timeInterval += Double(m) * 30 * 24 * 3600
        }
    }
    mutating func addYear(year y:Int) {
        let (year, month, day) = getDay()
        let (hour, minute, second) = getTime()
        let era = year / 100
        if let date = NSCalendar.currentCalendar().dateWithEra(era, year: year + y, month: month, day: day, hour: hour, minute: minute, second: second, nanosecond: 0) {
            timeInterval = date.timeIntervalSince1970
        } else {
            timeInterval += Double(y) * 365 * 24 * 3600
        }
    }
}

// MARK: - 判断
extension Date : BidirectionalIndexType {
    func between(begin:Date,_ over:Date) -> Bool {
        return (self >= begin && self <= over) || (self >= over && self <= begin)
    }
    func between(range:Range<Date>) -> Bool {
        return self >= range.startIndex && self <= range.endIndex
    }
    
    func successor() -> Date { return self + 1 }
    func predecessor() -> Date { return self - 1 }
}

extension Date {
    var isBissextileYear:Bool {
        let (year, _, _) = getDay()
        return year % 4 == 0
    }
    var isFebruary:Bool {
        let (_, month, _) = getDay()
        return month == 2
    }
    //let date : NSDate
}

extension Date {
    func earlierDate(anotherDate: Date) -> Date { return min(self, anotherDate) }
    func laterDate(anotherDate: Date) -> Date { return max(self, anotherDate) }

}

// MARK: - 获取 日期 或 时间
extension Date {
    
    // for example : let (year, month, day) = date.getDay()
    func getDay() -> (year:Int, month:Int, day:Int) {
        var year:Int = 0, month:Int = 0, day:Int = 0
        let date = NSDate(timeIntervalSince1970: timeInterval)
        NSCalendar.currentCalendar().getEra(nil, year: &year, month: &month, day: &day, fromDate: date)
        return (year, month, day)
    }
    
    // for example : let (hour, minute, second) = date.getTime()
    func getTime() -> (hour:Int, minute:Int, second:Int) {
        var hour:Int = 0, minute:Int = 0, second:Int = 0
        let date = NSDate(timeIntervalSince1970: timeInterval)
        NSCalendar.currentCalendar().getHour(&hour, minute: &minute, second: &second, nanosecond: nil, fromDate: date)
        return (hour, minute, second)
    }
}

// MARK: - 构造函数
extension Date {
    init(year:Int, month:Int = 1, day:Int = 1, hour:Int = 0, minute:Int = 0, second:Int = 0) {
        let era = year / 100
        if let date = NSCalendar.currentCalendar().dateWithEra(era, year: year, month: month, day: day, hour: hour, minute: minute, second: second, nanosecond: 0) {
            timeInterval = date.timeIntervalSince1970
        }
    }
}

extension Date {
    init(_ v: NSTimeInterval) { timeInterval = v }
    
    init(_ v: NSTimeInterval, sinceDate:Date) {
        let date = NSDate(timeIntervalSince1970: sinceDate.timeInterval)
        timeInterval = NSDate(timeInterval: v, sinceDate: date).timeIntervalSince1970
    }
    
    init(sinceNow: NSTimeInterval) {
        timeInterval = NSDate(timeIntervalSinceNow: sinceNow).timeIntervalSince1970
    }
    
    init(sinceReferenceDate: NSTimeInterval) {
        timeInterval = NSDate(timeIntervalSinceReferenceDate: sinceReferenceDate).timeIntervalSince1970
    }
}

extension Date {
    init(_ v: String, style: NSDateFormatterStyle) {
        var formatter = NSDateFormatter()
        formatter.dateStyle = style
        if let date = formatter.dateFromString(v) {
            self.timeInterval = date.timeIntervalSince1970
        } else {
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = formatter.dateFromString(v) {
                self.timeInterval = date.timeIntervalSince1970
            } else {
                assert(DEBUG == 0, "日期字符串格式异常[\(v)] at line:\(__LINE__) at column:\(__COLUMN__)")//__FILE__,__FUNCTION__
            }
        }
    }
    
    init(_ v: String, dateFormat:String = "yyyy-MM-dd HH:mm:ss") {
        var formatter = NSDateFormatter()
        formatter.dateFormat = dateFormat
        if let date = formatter.dateFromString(v) {
            self.timeInterval = date.timeIntervalSince1970
        } else {
            assert(DEBUG == 0, "日期字符串格式异常[\(v)] at line:\(__LINE__) at column:\(__COLUMN__)") //__FILE__,__FUNCTION__
        }
    }
}

extension Date {
    init(_ v: UInt8) { timeInterval = Double(v) }
    init(_ v: Int8) { timeInterval = Double(v) }
    init(_ v: UInt16) { timeInterval = Double(v) }
    init(_ v: Int16) { timeInterval = Double(v) }
    init(_ v: UInt32) { timeInterval = Double(v) }
    init(_ v: Int32) { timeInterval = Double(v) }
    init(_ v: UInt64) { timeInterval = Double(v) }
    init(_ v: Int64) { timeInterval = Double(v) }
    init(_ v: UInt) { timeInterval = Double(v) }
    init(_ v: Int) { timeInterval = Double(v) }
}

extension Date {
    init(_ v: Float) { timeInterval = Double(v) }
    //init(_ v: Float80) { timeInterval = Double(v) }
}

// MARK: - 可以直接输出
extension Date : Printable {
    var description: String {
        return NSDate(timeIntervalSince1970: timeInterval).description
    }
}
extension Date : DebugPrintable {
    var debugDescription: String {
        return NSDate(timeIntervalSince1970: timeInterval).debugDescription
    }
}

// MARK: - 可以直接赋值整数
extension Date : IntegerLiteralConvertible {
    static func convertFromIntegerLiteral(value: IntegerLiteralType) -> Date {
        return Date(Double(value))
    }
}

// MARK: - 可以直接赋值浮点数
extension Date : FloatLiteralConvertible {
    static func convertFromFloatLiteral(value: Double) -> Date {
        return Date(value)
    }
}

extension Date :StringLiteralConvertible {
    static func convertFromStringLiteral(value: String) -> Date {
        return Date(value)
    }
    static func convertFromExtendedGraphemeClusterLiteral(value: String) -> Date {
        return Date(value)
    }

}

/*
// __conversion() 功能不再允许
extension Date {
    func __conversion() -> NSDate { return NSDate(timeIntervalSince1970: timeInterval) }
    func __conversion() -> Double { return timeInterval }
    func __conversion() -> Int64 { return Int64(timeInterval) }
}
*/

// MARK: - 转日期
extension Date {
    var object: NSDate { return NSDate(timeIntervalSince1970: timeInterval) }
    init(_ v:NSDate) { self.timeInterval = v.timeIntervalSince1970 }
}
extension NSDate {
    var value:Date { return Date(timeIntervalSince1970) }
    convenience init(_ v:Date) { self.init(timeIntervalSince1970: v.timeIntervalSince1970) }
}

// MARK: - 可以直接赋值日期
protocol DateLiteralConvertible {
    typealias DateLiteralType
    class func convertFromDateLiteral(value: DateLiteralType) -> Self
}
typealias DateLiteralType = Date

extension Date : DateLiteralConvertible {
    //typealias DateLiteralType = NSDate

    static func convertFromDateLiteral(value: NSDate) -> Date {
        return Date(value.timeIntervalSince1970)
    }
}
extension NSDate : FloatLiteralConvertible {
    public class func convertFromFloatLiteral(value: FloatLiteralType) -> Self {
        return self(timeIntervalSince1970: value)
    }
}
extension NSDate : DateLiteralConvertible {
    class func convertFromDateLiteral(value: Date) -> Self {
        return self(timeIntervalSince1970: value.timeInterval)
    }
}

// MARK: - 可反射
extension Date : Reflectable {
    func getMirror() -> MirrorType {
        return reflect(self)
    }
}

// MARK: - 可哈希
extension Date : Hashable {
    var hashValue: Int { return timeInterval.hashValue }
}

// 可以用 == 或 != 对比
extension Date : Equatable {
    
}

// MARK: - 可以用 > < >= <= 对比
extension Date : Comparable {
    
}
