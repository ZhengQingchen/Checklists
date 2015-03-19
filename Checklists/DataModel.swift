//
//  DataModel.swift
//  Checklists
//
//  Created by mac on 15/1/6.
//  Copyright (c) 2015年 mac. All rights reserved.
//

import Foundation



class DataModel {
    var checklists = [Checklist]()
    var indexOfSelectedChecklist:Int {
        get{
            return NSUserDefaults.standardUserDefaults().integerForKey("ChecklistIndex")
        }
        set{
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "ChecklistIndex")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    init(){
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    class func nextChecklistItemID() -> Int{
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let itemID = userDefaults.integerForKey("ChecklistItemID")
        userDefaults.setInteger(itemID+1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }
    
    
    // MARK: - FILE FUNC
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as [String]
        let path = paths[0]
        
        return path
    }
    
    func dataFilePath() -> String{
        return documentsDirectory().stringByAppendingPathComponent("Checklists.plist")
    }
    
    func saveChecklists(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(checklists, forKey: "Checklists")
        archiver.finishEncoding()
        
        let x = data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadChecklists(){
        let path = dataFilePath()
        
        if NSFileManager.defaultManager().fileExistsAtPath(path){
            if let data = NSData(contentsOfFile: path){
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                checklists = unarchiver.decodeObjectForKey("Checklists") as [Checklist]
                unarchiver.finishDecoding()
                sortChecklists()
            }
        }
    }
    
    func sortChecklists(){
        checklists.sort({ checklist1,checklist2 in return
            checklist1.name.localizedStandardCompare(checklist2.name) == NSComparisonResult.OrderedAscending
        })
    }
    
    func registerDefaults ( ) {
        let dictionary = ["ChecklistIndex": -1,"FirstTime":true,"ChecklistItemID":0]
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
    func handleFirstTime(){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let firstTime = userDefaults.boolForKey("FirstTime")
        if firstTime {
            let checklist = Checklist(name: "List")
            checklists.append(checklist)
            indexOfSelectedChecklist = 0
            userDefaults.setBool(false, forKey: "FirstTime")
        }
    }
}