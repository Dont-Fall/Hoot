//
//  SignUpViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 12/30/15.
//  Copyright © 2015 Nitrox Development. All rights reserved.
//

import Foundation
import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Extras
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150))
    
    //MARK: Text Fields
    @IBOutlet var signUpEmailTF: UITextField!
    @IBOutlet var signUpPasswordTF: UITextField!
    @IBOutlet var signUpSchoolTF: UITextField!
    @IBOutlet var signUpUsernameTF: UITextField!
    
    //MARK: Picker View
    @IBOutlet var signUpSchoolPicker: UIPickerView!
    
    //MARK: School Data
    var schoolListUnsorted: [String] = [String]()
    var schoolList: [String] = [String]()
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Keyboard up at start
        signUpUsernameTF.becomeFirstResponder()
        
        //Change Color For School Picker
        self.signUpSchoolPicker.setValue(UIColor.greenColor(), forKey: "textColor")
        
        //Taps to close
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        //Delegate Text Fields/Pickers
        signUpSchoolTF.delegate = self
        signUpSchoolPicker.hidden = true
        self.signUpSchoolPicker.delegate = self
        self.signUpSchoolPicker.dataSource = self
        
        //School Data
        schoolListUnsorted = ["Rutgers University-New Brunswick", "Stevens Institute of Technolgoy", "Rutgers University-Newark", "Montclair State University", "Rowan University", "The College of New Jersey", "New Jersey Institute of Technology"]
        schoolList = schoolListUnsorted.sort()
    }
    
    //DID RECIEVE MEMORY WARNING
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    //Returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        return schoolList.count
    }
    
    //Determins Picker View Row
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        return schoolList[row]
    }
    
    //Assigns Picker View to Text Field
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int){
        signUpSchoolTF.text = schoolList[row]
        signUpSchoolPicker.hidden = true;
    }
    
    //MARK:MBring Up Editor on Text Field Tap
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        view.endEditing(true)
        signUpSchoolPicker.hidden = false
        return false
    }
    
    //MARK: Tap Function
    func dismissKeyboard() {
        //Causes view/text field to resign to first responder.
        view.endEditing(true)
    }
    
    //MARK: Create Account
    @IBAction func signUpCreateBtn(sender: AnyObject) {
        var user = PFUser()
        user.username = signUpUsernameTF.text
        user.password = signUpPasswordTF.text
        user.email = signUpEmailTF.text
        user["school"] = signUpSchoolTF.text
        user["points"] = 0
        user["subject"] = "Math"
        user["currentGroupCode"] = ""
        user.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if error == nil {
                // Success, no creating error.
                self.actInd.startAnimating()
                self.performSegueWithIdentifier("signUpSuccess", sender: self)
                self.actInd.stopAnimating()
                
            } else {
                print("Error")
            }
        }
    }
}