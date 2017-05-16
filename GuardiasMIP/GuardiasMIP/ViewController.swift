//
//  ViewController.swift
//  GuardiasMIP
//
//  Created by Ernesto Sánchez Kuri on 26/06/16.
//  Copyright © 2016 Sankurlabs. All rights reserved.
//

import UIKit
import EasyPickerKit.CustomPickerViewController
import EasyPickerKit.CustomDatePickerViewController

class ViewController: UIViewController, CustomDatePickerDelegate {
    @IBOutlet weak var btnStartingDate: UIButton!
    @IBOutlet weak var btnEndingDate: UIButton!
    var datePicker = CustomDatePickerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        btnStartingDate.addTarget(self, action: #selector(ViewController.showDatePicker(_:)), forControlEvents: .TouchUpInside)
        btnEndingDate.addTarget(self, action: #selector(ViewController.showDatePicker(_:)), forControlEvents: .TouchUpInside)
        datePicker = CustomDatePickerViewController.init(delegate: self)
        datePicker.pickerHeight = self.view.frame.size.height
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loadUI() {
        btnStartingDate.titleLabel?.textAlignment = .Center
        btnEndingDate.titleLabel?.textAlignment = .Center
        
    }
    
    func showDatePicker(btn : UIButton) {
        var parent = self.parentViewController?.parentViewController
        if parent == nil {
            parent = self.parentViewController
        }
        if parent == nil {
            parent = self
        }
        if btn.tag == 1001 {
            datePicker.pickerTag = 1001
        } else {
            datePicker.pickerTag = 1002
        }
        
        datePicker.showDatePickerInViewController(self)
        
    }
    
    func picker(picker: CustomDatePickerViewController!, pickedDate date: NSDate!) {
         let dateFormatted = date.toString(format: .Custom("dd/MM/YYYY"))
        switch picker.pickerTag as! Int {
        case 1001:
            btnStartingDate.titleLabel?.text = "\(dateFormatted)"
            break
        case 1002:
            btnEndingDate.titleLabel?.text = "\(dateFormatted)"
            break
        default:
            break
        }
    }
    
    func datePickerWasCancelled(picker: CustomDatePickerViewController!) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

