//
//  DropDownList.swift
//  iOSPond
//
//  Created by iOSPond on 11/07/16.
//  Copyright © 2016 iOSPond. All rights reserved.
//

import UIKit
/*!
 
 - author: iOSPond
 I defined enum so that I can group my constants here.
 
 - cellIdentifier: This is identity of the cell for dropdown list tableview
 */
enum constant:String {
    case cellIdentifier="CellIdentity"
}

public class SwiftDropDownList: UITextField, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    //MARK: - Global Vars
    private var tblView:UITableView!
    var arrayList:NSArray=NSArray()
    static var arrList:NSArray!
    var isArrayWithObject:Bool = false
    var isDismissWhenSelected = true
    public var isKeyboardHidden=false
    public var keyPath:String!
    public var textField:UITextField!
    private var arrFiltered:NSArray!
    var superViews:UIView!
    //MARK:- Delegate object
    public weak var delegates:DropDownListDelegate!
    //MARK:- Class constructor
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate=self
        self.tblView=UITableView()
        
        self.tblView.delegate=self
        self.tblView.dataSource=self
        self.tblView.registerClass(UITableViewCell.self, forCellReuseIdentifier: constant.cellIdentifier.rawValue)
    }
    convenience init(){
        self.init()
        
    }
    //MARK:- TextField delegate methods
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let myStr = textField.text! as NSString
        let finalString =  myStr.stringByReplacingCharactersInRange(range, withString: string)
        if isArrayWithObject{
            if finalString.isEmpty{
                arrFiltered = arrayList
            }else{
                let pred=NSPredicate(format: "\(keyPath) beginswith[c] '\(finalString)'")
                self.arrFiltered = arrayList.filteredArrayUsingPredicate(pred)
            }
        }else{
            let array:[AnyObject]=arrayList as [AnyObject]
            if finalString.isEmpty{
                arrFiltered = arrayList
            }else{
                arrFiltered =  array.filter{($0 as! String) .localizedCaseInsensitiveContainsString(finalString)}
            }
            
        }
        
        
        print(self.arrFiltered)
        self.tblView.reloadData()
        return true
    }
    
    public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if self.tblView.frame.size.height > 0{
            UIView.animateWithDuration(0.5, animations: {
                self.tblView.frame.size.height=0
            })
        }else{
            textField.resignFirstResponder()
            self.tblView.frame.size.width=textField.frame.size.width
            self.tblView.frame.origin.x=textField.frame.origin.x
            self.tblView.frame.size.height=0
            self.tblView.layer.borderWidth = 1
            self.tblView.layer.borderColor = textField.layer.borderColor
            self.textField=textField
            
            self.arrFiltered = self.arrayList
            
            self.getSuperView(self.superview!)
            let rect = superViews.convertRect(textField.frame, fromView: textField.superview)
            self.tblView.frame.origin.y = rect.origin.y + rect.size.height-2
            self.tblView.frame.origin.x = rect.origin.x
            
            UIView.animateWithDuration(0.5, animations: {
                self.tblView.frame.size.height=200
                self.superViews.addSubview(self.tblView)
                self.tblView.reloadData()
            })
            
            
        }
        return !isKeyboardHidden
    }
    public func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        UIView.animateWithDuration(0.5, animations: {
            self.tblView.frame.size.height=0
        })
        textField.resignFirstResponder()
        return true
    }
    public func textFieldDidEndEditing(textField: UITextField) {
        UIView.animateWithDuration(0.5, animations: {
            self.tblView.frame.size.height=0
        })
    }
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        UIView.animateWithDuration(0.5, animations: {
            self.tblView.frame.size.height=0
        })
        textField.resignFirstResponder()
        return true
    }
    //MARK: - Custome Methods
    func getSuperView(views:UIView){
        superViews = views.superview
        if superViews.frame.size.height < 200{
            getSuperView(superViews!)
        }
    }
    
    //MARK- TableView Delegate
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFiltered.count
    }
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(constant.cellIdentifier.rawValue)
        if isArrayWithObject {
            cell?.textLabel?.text = self.arrFiltered.objectAtIndex(indexPath.row).valueForKey(keyPath) as? String
            
        }else{
            cell?.textLabel?.text=self.arrFiltered.objectAtIndex(indexPath.row) as? String
        }
        return cell!
    }
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let object =  self.arrFiltered.objectAtIndex(indexPath.row)
        if delegates != nil{
            self.delegates.dropDownSelectedIndex(indexPath.row, textField: self.textField, object: object)
        }
        if !isArrayWithObject {
            textField.text = object as? String
        }else{
            textField.text = object.valueForKeyPath(keyPath) as? String
        }
        if isDismissWhenSelected {
            UIView.animateWithDuration(0.5, animations: {
                self.tblView.frame.size.height=0
                }, completion: { (value: Bool) in
                    self.tblView.removeFromSuperview()
                    self.resignFirstResponder()
            })
            
        }
    }
}
//MARK:- Protocol
public protocol DropDownListDelegate:class {
    /*!
     
     - author: iOSPond
     This delegate method will call when user will select any option from dropdown list
     
     - parameter index:     index which user select
     - parameter textField: textField from which drop down is apeared
     - parameter object:    object that which is currently selected
     */
    func dropDownSelectedIndex(index:Int, textField:UITextField, object:AnyObject)
}

