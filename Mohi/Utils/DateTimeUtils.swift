//
//  DateTimeUtils.swift
//  Flum
//
//  Created by Pawan Jat on 07/02/17.
//  Copyright © 2017 47billion. All rights reserved.
//

import Foundation

class DateTimeUtils {
    
    static let sharedInstance = DateTimeUtils()
 
    static let MILLI_SECOND_IN_HOUR:Double = 1000*60*60 //long
    static let MILLI_SECOND_IN_TWO_HOUR:Double = MILLI_SECOND_IN_HOUR * 2
    static let MILLI_SECOND_IN_DAY:Double = MILLI_SECOND_IN_HOUR*24;
    
//    private let DF_TIME_hh_mm_aa = "hh:mm a"
//    private let DF_TIME_yyyy_MM_dd = "yyyy-MM-dd"
//    private let DF_MMMM_dd_yyyy_HHmmaa = "yyyy hh:mm a"
//    private let DF_ISO_8601 = "yyyy-MM-dd 'T' HH:mm:ss 'Z'"
    
    private var DF_TIME_hh_mm_aa:DateFormatter?
    private var DF_TIME_yyyy_MM_dd:DateFormatter?
    private var DF_MMMM_dd_yyyy_HHmmaa:DateFormatter?
    
    private var DF_TIME_dd_MMM_yy:DateFormatter?
    private var  DF_TIME_dd_MMMM_yyyy:DateFormatter?
    
    private var DF_ISO_8601:DateFormatter?

    private var msgTimeTextAnHourAgo:String?
    private var msgTimeTextTodayAt:String?
    private var msgTimeTextYesterdayAt:String?
    
    init(){
        loadFormatter()
        loadFormatterText()
    }
    
    //@SuppressLint("DefaultLocale")
    func formatTimeSeconds(timeInSeconds:CLong) -> String{
        let second = timeInSeconds % 60;
        let minute = (timeInSeconds / 60) % 60;
        let hour = (timeInSeconds / (60 * 60)) % 24;
        return String(format: "%02d:%02d:%02d", hour, minute, second)
    }
    
//    @SuppressLint("DefaultLocale")
    func formatTimeSecondsReturnsMin(timeInSeconds:CLong) ->String{
        let second = timeInSeconds % 60
        let minute = (timeInSeconds / 60) % 60
        return String(format:"%02d:%02d", minute, second)
    }
//
    func loadFormatter() {
        
        DF_TIME_hh_mm_aa = DateFormatter()
        if(DF_TIME_hh_mm_aa != nil){
            DF_TIME_hh_mm_aa?.dateFormat = "hh:mm a"
            DF_TIME_hh_mm_aa?.timeZone = TimeZone.current
            DF_TIME_hh_mm_aa?.locale = Locale.current
        }

        
        DF_TIME_yyyy_MM_dd = DateFormatter()
        if(DF_TIME_yyyy_MM_dd != nil){
            DF_TIME_yyyy_MM_dd?.dateFormat = "yyyy-MM-dd"
            DF_TIME_yyyy_MM_dd?.timeZone = TimeZone.current
            DF_TIME_yyyy_MM_dd?.locale = Locale.current
        }
        
        //
        DF_TIME_dd_MMM_yy = DateFormatter()
        if(DF_TIME_dd_MMM_yy != nil){
            DF_TIME_dd_MMM_yy?.dateFormat = "dd MMM yy"
            DF_TIME_dd_MMM_yy?.timeZone = TimeZone.current
            DF_TIME_dd_MMM_yy?.locale = Locale.current
        }

        
        DF_MMMM_dd_yyyy_HHmmaa = DateFormatter()
        if(DF_MMMM_dd_yyyy_HHmmaa != nil){
            DF_MMMM_dd_yyyy_HHmmaa?.dateFormat = "MMMM dd yyyy hh:mm a"
            DF_MMMM_dd_yyyy_HHmmaa?.timeZone = TimeZone.current
            DF_MMMM_dd_yyyy_HHmmaa?.locale = Locale.current
        }

        DF_ISO_8601 = DateFormatter()
        if(DF_ISO_8601 != nil){
            DF_ISO_8601?.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            DF_ISO_8601?.timeZone = TimeZone.current
            DF_ISO_8601?.locale = Locale.current
        }
        
        DF_TIME_dd_MMMM_yyyy = DateFormatter()
        if(DF_TIME_dd_MMMM_yyyy != nil){
            DF_TIME_dd_MMMM_yyyy?.dateFormat = "dd MMMM yyyy"
            DF_TIME_dd_MMMM_yyyy?.timeZone = TimeZone.current
            DF_TIME_dd_MMMM_yyyy?.locale = Locale.current
        }
    }

    func loadFormatterText() { //Must reloaded in case of locale change.
        msgTimeTextAnHourAgo = BaseApp.sharedInstance.getMessageForCode("msg_time_an_hour_ago", fileName: "Strings")!
        msgTimeTextTodayAt = BaseApp.sharedInstance.getMessageForCode("msg_time_today_at", fileName: "Strings")!
        msgTimeTextYesterdayAt = BaseApp.sharedInstance.getMessageForCode("msg_time_yesterday_at", fileName: "Strings")!
    }
    
    func reminderDateTimeFormat(date:Date) ->String? {
        return (DF_MMMM_dd_yyyy_HHmmaa?.string(from: date))! //TODO change format as required.
    }
    
    func formatSimpleTime(date:Date) ->String? {
        return (DF_TIME_hh_mm_aa?.string(from: date))! //TODO change format as required.
    }
    
    func formatSimpleDateTime(date:Date) ->String? {
        return (DF_MMMM_dd_yyyy_HHmmaa?.string(from: date))! //TODO change format as required.
    }
    
    func  formatSimpleDate(date:Date) -> String{
        //return DF_TIME_dd_MMM_yy.format(date);
        return (DF_TIME_dd_MMM_yy?.string(from: date))! //TODO change format as required.
    }

    func parseISO8601Date(dateStr:String) -> Date?{
        if(!dateStr.isEmpty){
            return DF_ISO_8601?.date(from: dateStr)
        }
        return nil
    }
    
    
    func julianDay(year:Int, month:Int, day:Int) -> Int{
        let a = (14 - month) / 12;
        let y = year + 4800 - a;
        let m = month + 12 * a - 3;
        return day + (153 * m + 2)/5 + 365*y + y/4 - y/100 + y/400 - 32045;
    }
    
    func julianDay(calendar:NSCalendar) -> Int{
        let date = Date()
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        return julianDay(year: year, month: month, day: day)
    }
    
    func julianToday() -> Int{
        return julianDay(calendar: NSCalendar.current as NSCalendar)
    }
    
    //MARK:- Time/Date conversion
    func getTimeStampFromSecond(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = totalSeconds / 3600
        
        var timeStamp = ""
        if(hours != 0 && minutes != 0){
            timeStamp = String(format: "%02d h:%02d m", hours, minutes)
        }else if(hours == 0 && minutes != 0){
            timeStamp = String(format: "%02d m",minutes)
        }else if(minutes == 0 && seconds != 0){
            timeStamp = String(format: "%02d s",seconds)
        }else if(seconds == 0){
            timeStamp = String(format: "0 s")
        }
        return timeStamp
    }
    
    func getDateFromUnixFormat(_ dateUnixFormate:Double) -> String {
        let date = Date(timeIntervalSince1970: dateUnixFormate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, hh:mm a"
        let dateString = dateFormatter.string(from: date)
        return dateString
        
    }
    
    func getDateTimeFromUnixFormat(_ dateUnixFormate:Double) -> String {
        let date = Date(timeIntervalSince1970: dateUnixFormate / 1000.0)
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = DateFormatter.Style.short
        timeFormatter.dateFormat = "hh:mm a"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let timeString = timeFormatter.string(from: date)
        let dateString = dateFormatter.string(from: date)
        let finalString = String(format:"%@ (%@)",timeString,dateString)
        return finalString
    }
    
    func getDateStrFromUnixFormat(_ dateUnixFormate:Double) -> String {
        let date = Date(timeIntervalSince1970: dateUnixFormate / 1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: date)
        let finalString = String(format:"%@",dateString)
        return finalString
    }
    
    func getDateFromTimeInterval(timeInterval:TimeInterval) -> Date{
        return Date(timeIntervalSince1970: timeInterval / 1000.0)
    }
    
    func getDateFromStringTimeInterval(timeInterval:String) -> Date?{
        let dateTimeMilliSecondString:String? = BaseApp.sharedInstance.removeOptionalWordFromString(timeInterval)
        
        if(dateTimeMilliSecondString != nil){
            let messageDate:Date? = self.getDateFromTimeInterval(timeInterval: Double(dateTimeMilliSecondString!)!)
            return messageDate
        }
        
        return nil
    }
}
