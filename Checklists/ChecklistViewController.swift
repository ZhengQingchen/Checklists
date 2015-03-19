//
//  ViewController.swift
//  Checklists
//
//  Created by mac on 15/1/3.
//  Copyright (c) 2015年 mac. All rights reserved.
//

import UIKit

struct HeightOfCell {
    static let SINGLELINECELLHEIGHT = 44.0
    static let DOUBLELINECELLHEIGHT = 78.0
    static let DATAPICKERROWHEIGHT = 217
}

class ChecklistViewController: UITableViewController,ItemDetailViewControllerDelegate{

    
    var items : [ChecklistItem]
    var checklist:Checklist!
    
    
    //MARK: - init func
    required init(coder aDecoder: NSCoder) {
        
        items = [ChecklistItem]()
        
        
        super.init(coder: aDecoder)
        
        
    }
    
    //MARK: - Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = checklist.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    //MARK: - TableView override  func
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  checklist.items.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if checklist.items[indexPath.row].shouldRemind{

            let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem") as UITableViewCell
            
            let item = checklist.items[indexPath.row]
        
            configureTextForCell(cell, item: item)
            configureCheckmarkForCell(cell, item : item)
            configureDateForCell(cell, item: item)
        
            return cell
        }else{
            
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItemNoDueDate") as UITableViewCell
            
            let item = checklist.items[indexPath.row]
            
            configureCheckmarkForCell(cell, item: item)
            configureTextForCell(cell, item: item)
           
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if checklist.items[indexPath.row].shouldRemind{
            return CGFloat(HeightOfCell.DOUBLELINECELLHEIGHT)
        }else{
            return CGFloat(HeightOfCell.SINGLELINECELLHEIGHT)
        }

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmarkForCell(cell,item:item)
            
            }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    // 删除
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //remove from the model
        checklist.items.removeAtIndex(indexPath.row)
        //remove from the view
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)

    }
    
    // MARK: - UI func for cell to show
    func configureCheckmarkForCell(cell:UITableViewCell,item:ChecklistItem){
        
        let label = cell.viewWithTag(1001) as UILabel
        label.textColor = view.tintColor
        if item.checked{
            label.text = "  √ "
        }else{
            label.text = ""
        }
    }
    
    func configureTextForCell(cell:UITableViewCell,item:ChecklistItem){
        let label = cell.viewWithTag(1000) as UILabel
        label.text = item.text
    }
    
    
    func configureDateForCell(cell:UITableViewCell,item:ChecklistItem){
        let label = cell.viewWithTag(1002) as? UILabel
        if item.shouldRemind {
            if item.dueDate.compare(NSDate()) != NSComparisonResult.OrderedAscending{
                let formatter = NSDateFormatter()
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle

                let string = "Due Date:"
                label?.text = string.stringByAppendingString(formatter.stringFromDate(item.dueDate))
            }else{
                label?.text = "Due Date passed"
            }
        }else{
            label?.text = "No Remind Date"
        }
        
    }
    
    // MARK: - itemDetailViewController IMP
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        // insert item in the view
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func itemDetailViewController(controller:ItemDetailViewController,didFinishEditItem item:ChecklistItem){
        
        if let index = find(checklist.items, item) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath){
                if item.shouldRemind{
                    configureTextForCell(cell, item: item)
                    configureDateForCell(cell, item: item)
                    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                }else{
                    configureTextForCell(cell, item: item)
                    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                }
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK:- Segue func
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as ItemDetailViewController
            
            controller.delegate = self
        }else if segue.identifier == "EditItem"{
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as ItemDetailViewController
            
            controller.delegate = self
            
            if let indexPath = tableView.indexPathForCell(sender as UITableViewCell){
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }else if segue.identifier == "EditItem2"{
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as ItemDetailViewController
            
            controller.delegate = self
            
            if let indexPath = tableView.indexPathForCell(sender as UITableViewCell){
                controller.itemToEdit = checklist.items[indexPath.row]
         
            }
        }
    }
}

