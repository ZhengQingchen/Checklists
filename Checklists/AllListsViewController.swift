//
//  AllListsViewController.swift
//  Checklists
//
//  Created by mac on 15/1/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController,ListDetailViewControllerDelegate,UINavigationControllerDelegate {
    
    
    
    var dataModel :DataModel!
    
    // MARK: Controller Life Cycle
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.checklists.count {
            let checklist = dataModel.checklists[index]
            performSegueWithIdentifier("ShowChecklist", sender: checklist)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //修改 subtitle的items 个数属性后显示值
        tableView.reloadData()
    }
    
    // MARK: -TableView Override delegate
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.checklists.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
        let checklist = dataModel.checklists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .DetailDisclosureButton
        let count = checklist.countUncheckedItems()
        if  checklist.items.count  == 0{
            cell.detailTextLabel!.text = "No items"
        }else if count == 0 && count != checklist.items.count{
            cell.detailTextLabel!.text = "All done of \(checklist.items.count) items"
        }else {
            cell.detailTextLabel!.text = "\(checklist.countUncheckedItems()) Ramaining of \(checklist.items.count) items"
        }
        cell.imageView!.image = UIImage(named: checklist.iconName)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.checklists[indexPath.row]
        performSegueWithIdentifier("ShowChecklist", sender: checklist)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.checklists.removeAtIndex(indexPath.row)
        let indexPaths = [indexPath]
        
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListNavigationController") as UINavigationController
        let controller = navigationController.topViewController as ListDetailViewController
        
        controller.delegate = self
        let checklist = dataModel.checklists[indexPath.row]
        
        controller.checklistToEdit = checklist
        
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if viewController === self{
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    //MARK: - listDetailViewControllerDelegate
    
    func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist checklist: Checklist) {
        let newRowIndex = dataModel.checklists.count
        dataModel.checklists.append(checklist)
        dataModel.sortChecklists()
     
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewController(controller:ListDetailViewController,didFinishEditingChecklist checklist:Checklist){
        if let index = find(dataModel.checklists,checklist){
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath){
              cell.textLabel?.text = checklist.name
            }
        }
        
        dataModel.sortChecklists()
        tableView.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK:- segue func
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destinationViewController as ChecklistViewController
            controller.checklist = sender as Checklist
        }else if segue.identifier == "AddChecklist" {
            let navigationController = segue.destinationViewController as UINavigationController
            let controller = navigationController.topViewController as ListDetailViewController
            
            controller.delegate = self
            controller.checklistToEdit = nil
        }
    }
    
    
    
}
