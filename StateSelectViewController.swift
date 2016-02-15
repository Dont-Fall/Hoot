//
//  StateSelectViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 2/6/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class StateSelectViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate {
    
    @IBOutlet var stateSelectTV: UITextView!
    @IBOutlet var stateSelectTF: UITextField!
    @IBOutlet var stateSelectPicker: UIPickerView!
    @IBAction func stateSelectNextBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("stateToTermSegue", sender: self)
    }
    
    @IBAction func stateSelectBackBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("stateBackSegue", sender: self)
    }
    var stateList = [
    "Alabama",
    "Alaska",
    "Arizona",
    "Arkansas",
    "California",
    "Colorado",
    "Connecticut",
    "Delaware",
    "Florida",
    "Georgia",
    "Hawaii",
    "Idaho",
    "Illinois",
    "Indiana",
    "Iowa",
    "Kansas",
    "Kentucky",
    "Louisiana",
    "Maine",
    "Maryland",
    "Massachusetts",
    "Michigan",
    "Minnesota",
    "Mississippi",
    "Missouri",
    "Montana",
    "Nebraska",
    "Nevada",
    "New Hampshire",
    "New Jersey",
    "New Mexico",
    "New York",
    "North Carolina",
    "North Dakota",
    "Ohio",
    "Oklahoma",
    "Oregon",
    "Pennsylvania",
    "Rhode Island",
    "South Carolina",
    "South Dakota",
    "Tennessee",
    "Texas",
    "Utah",
    "Vermont",
    "Virginia",
    "Washington",
    "West Virginia",
    "Wisconsin",
    "Wyoming"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        //Delegate Text Fields/Pickers
        self.stateSelectPicker.delegate = self
        self.stateSelectPicker.dataSource = self
        stateSelectTF.delegate = self
        UIApplication.sharedApplication().statusBarStyle = .Default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    //Returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        return stateList.count
    }
    
    //Determins Picker View Row
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        return stateList[row]
    }
    
    //Assigns Picker View to Text Field
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int){
        stateSelectTF.text = stateList[row]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stateToTermSegue" {
            var detailScene = segue.destinationViewController as! TermsViewController
            detailScene.state = stateSelectTF.text
        }
    }

}
