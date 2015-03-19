//
//  ChecklistItem.swift
//  Checklists
//
//  Created by mac on 15/1/4.
//  Copyright (c) 2015年 mac. All rights reserved.
//

import Foundation
import UIKit
class ChecklistItem :NSObject,NSCoding{
    var text = ""
    var checked = false
    var dueDate = NSDate()
    var shouldRemind = false
    var itemID:Int
    
    func toggleChecked(){
        checked = !checked
    }
    
    
    // MARK localNotification func
    
    func scheduleNotification(){
        let existingNotification = notificationForThisItem()
        if let notification = existingNotification{
            println("Found an existing notification \(notification)")
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
        
        if shouldRemind && dueDate.compare(NSDate()) != NSComparisonResult.OrderedAscending{
            let localNotification = UILocalNotification()
            localNotification.fireDate = dueDate
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.alertBody = text
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.userInfo = ["itemID":itemID]
            
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            
            println("Scheduled notification \(localNotification) for itemID \(itemID)")
        }
    }
    
    func notificationForThisItem() -> UILocalNotification?{
        let allnotifications = UIApplication.sharedApplication().scheduledLocalNotifications as [UILocalNotification]
        
        for notification in allnotifications {
            if let number = notification.userInfo?["itemID"] as? NSNumber{
                
                println(number)
                if number.integerValue == itemID {
                    println("found")
                    return notification
                }
            }
        }
        
        return nil
    }
    
    // MARK - IMP NSCoding
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(checked, forKey: "Checked")
        aCoder.encodeObject(dueDate,forKey:"DueDate")
        aCoder.encodeBool(shouldRemind, forKey: "ShouldRemind")
        aCoder.encodeInteger(itemID, forKey: "ItemID")
    }
    required init(coder aDecoder: NSCoder){
        
        text = aDecoder.decodeObjectForKey("Text") as String
        checked = aDecoder.decodeBoolForKey("Checked")
        dueDate = aDecoder.decodeObjectForKey("DueDate") as NSDate
        shouldRemind = aDecoder.decodeBoolForKey("ShouldRemind")
        itemID = aDecoder.decodeIntegerForKey("ItemID")
        super.init()
    }
    
    override init() {
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    deinit{
        let existingNotification = notificationForThisItem()
        if let notification = existingNotification{
            println("Found an existing notification \(notification)")
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
    }
}