//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by mac on 15/1/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

import UIKit
// MARK:- protocol ListDetailViewControllerDelegate
protocol ListDetailViewControllerDelegate: class{
    func listDetailViewControllerDidCancel(controller:ListDetailViewController)
    func listDetailViewController(controller:ListDetailViewController,didFinishAddingChecklist checklist:Checklist)
    func listDetailViewController(controller:ListDetailViewController,didFinishEditingChecklist checklist:Checklist)
}

class ListDetailViewController: UITableViewController,UITextFieldDelegate,IconPickViewControllerDelegate {
    @IBOutlet weak var textField :UITextField!
    @IBOutlet weak var doneBarButton:UIBarButtonItem!
    @IBOutlet weak var iconImageView: UIImageView!
    
    weak var delegate:ListDetailViewControllerDelegate?
    var iconName = "Folder"
    var checklistToEdit:Checklist?
    
    // MARK: Controller Life Cycle func
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.enabled = true
            iconName = checklist.iconName
        }
        
        iconImageView.image = UIImage(named: iconName)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
       
    }
    // MARK:- UIAction func
    @IBAction func cancel(){
        delegate?.listDetailViewControllerDidCancel(self)
    }
    @IBAction func done(){
        if let checklist = checklistToEdit {
            checklist.name = textField.text
            checklist.iconName = iconName
            delegate?.listDetailViewController(self, didFinishEditingChecklist: checklist)
        }else{
            let checklist = Checklist(name: textField.text, iconName: iconName)
            delegate?.listDetailViewController(self, didFinishAddingChecklist: checklist)
        }
    }
    // MARK: TableView override
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1{
            return indexPath
        }else{
            return nil
        }
    }
    
    //MARK: textField delegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText:NSString = textField.text
        let newText:NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        doneBarButton.enabled = (newText.length > 0)
        
        return true
    }
    
    //MARK: iconPick  delegate
    func iconPick(pick: IconPickViewController, didPickIcon iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
        // Icon Picker is on the navigation stack not  call dismissViewController()
        navigationController?.popViewControllerAnimated(true)
    }
    //MARK: Segue func
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickIcon"{
            let controller = segue.destinationViewController as IconPickViewController
            controller.title = "Choose Icon"
            controller.delegate = self
        }
    }
}
