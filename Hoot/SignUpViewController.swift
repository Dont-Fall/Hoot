//
//  SignUpViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 12/30/15.
//  Copyright © 2015 Nitrox Development. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate {
    
    
    //MARK: Text Fields
    @IBOutlet var signUpEmailTF: UITextField!
    @IBOutlet var signUpPasswordTF: UITextField!
    @IBOutlet var signUpSchoolTF: UITextField!
    @IBOutlet var signUpUsernameTF: UITextField!
    @IBOutlet weak var signUpConfirmPasswordTF: UITextField!
    
    //MARK: Labels
    @IBOutlet weak var errorLabel: UILabel!
    
    //MARK: Picker View
    @IBOutlet var signUpSchoolPicker: UIPickerView!
    
    //MARK: School Data
    var schoolListUnsorted: [String] = [String]()
    var schoolList: [String] = [String]()
    var testList = Array<String>()
    var school = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .Default
        //Keyboard up at start
        signUpUsernameTF.becomeFirstResponder()
        
        //Taps to close
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        //Delegate Text Fields/Pickers
        signUpSchoolPicker.hidden = true
        self.signUpSchoolPicker.delegate = self
        self.signUpSchoolPicker.dataSource = self
        signUpSchoolTF.delegate = self

        schoolList = self.schoolListUnsorted.sort()
    }
    
    //DID RECIEVE MEMORY WARNING
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    //Returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return schoolList.count
    }
    
    //Determins Picker View Row
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return schoolList[row]
    }
    
    //Assigns Picker View to Text Field
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        signUpSchoolTF.text = schoolList[row]
        signUpSchoolPicker.hidden = true;
    }
    
    //MARK: Bring Up Editor on Text Field Tap
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
        errorLabel.text = ""
        view.endEditing(true)
        let signup = SignUp(uName: signUpUsernameTF.text!, email: signUpEmailTF.text!, pass: signUpPasswordTF.text!, confirmPass: signUpConfirmPasswordTF.text!, school: signUpSchoolTF.text!, subject: "Math", points: 0, groupCode: "", tokens: 10, dailyTokenAvail: true, dailyCD: NSDate(), tweet: false, facebook: false)
        do {
            try signup.signUpUser()
            let signin = SignIn(user: signUpUsernameTF.text!, pass: signUpPasswordTF.text!)
            do {
                try signin.signInUser()
                //let currentInstallation = PFInstallation.currentInstallation()
                self.performSegueWithIdentifier("signUpSuccess", sender: self)
            }catch let error as Error {
                //dismissKeyboard()
                errorLabel.text = error.description
            } catch {
                errorLabel.text = "Sorry, something went\n wrong please try again."
            }
        }catch let error as Error {
            //dismissKeyboard()
            errorLabel.text = error.description
        }catch {
            errorLabel.text = "Sorry, something went wrong please try again."
        }
    
    }
    
    //ADD SCHOOL BTN
    @IBAction func signUpAddSchoolBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("addSchoolSegue", sender: self)
    }
    
    //OPTIONAL
    func signUpSuccessAlert() -> UIAlertController {
        let alertview = UIAlertController(title: "Sign up Successful", message: "Now you can log in for complete access.", preferredStyle: .Alert)
        alertview.addAction(UIAlertAction(title: "Login", style: .Default, handler: { (alertAction) ->Void in self.dismissViewControllerAnimated(true, completion: nil) }))
        alertview.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        return alertview
    }
    
}