//
//  ViewController.swift
//  SwiftDropDownList
//
//  Created by satyendra chauhan on 09/20/2016.
//  Copyright (c) 2016 satyendra chauhan. All rights reserved.
//

import UIKit
import SwiftDropDownList

class ViewController: UIViewController, DropDownListDelegate {
    @IBOutlet weak var txt:SwiftDropDownList!
    override func viewDidLoad() {
        super.viewDidLoad()
        txt.isKeyboardHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dropDownSelectedIndex(index:Int, textField:UITextField, object:AnyObject){
        
    }
}

