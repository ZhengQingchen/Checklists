//
//  IconPickViewController.swift
//  Checklists
//
//  Created by mac on 15/1/6.
//  Copyright (c) 2015年 mac. All rights reserved.
//

import UIKit

protocol IconPickViewControllerDelegate:class{
    func iconPick(pick:IconPickViewController,didPickIcon iconName:String)
}

class IconPickViewController: UITableViewController {
    weak var delegate:IconPickViewControllerDelegate?
    let icons = ["No Icon",
        "Appointments",
        "Birthdays",
        "Chores",
        "Drinks",
        "Folder",
        "Groceries",
        "Inbox",
        "Photos",
        "Trips"];
    
        
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return icons.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IconCell") as UITableViewCell
        let iconName = icons[indexPath.row]
        
        cell.textLabel!.text = iconName
        cell.imageView!.image = UIImage(named: iconName)
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let delegate = delegate{
            let iconName = icons[indexPath.row]
            delegate.iconPick(self, didPickIcon: iconName)
        }
    }
    
}