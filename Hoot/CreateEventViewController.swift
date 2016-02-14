//
//  CreateEventViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/3/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UITextViewDelegate {
    
    //MARK: Text Fields
    @IBOutlet var createEventNameTF: UITextField!
    @IBOutlet var createEventDateTF: UITextField!
    @IBOutlet var createEventLocationTF: UITextField!
    @IBOutlet var createEventTV: UITextView!
    @IBOutlet var eventDescriptionCount: UILabel!
    
    //MARK: Date Pickers Outlets
    @IBOutlet var createEventDatePicker: UIDatePicker!
    //@IBOutlet var createEventTimePicker: UIDatePicker!
    
    //MARKL: Date Picker Actions
    @IBAction func createEventDatePickerActn(sender: AnyObject) {
        createEventDatePicker.hidden = false
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        var strDate = dateFormatter.stringFromDate(createEventDatePicker.date)
        self.createEventDateTF.text = strDate
    }
    
    //MARK: Assign
    let dateFormatter = NSDateFormatter()
    let timeFormatter = NSDateFormatter()
    
    //MARK: Date
    func setDate() {
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        createEventDateTF.text = dateFormatter.stringFromDate(createEventDatePicker.date)
    }
    
    //VIEW DID APPEAR
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        //Hide Tab Bar
        self.tabBarController?.tabBar.hidden = true
    }
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        var currentDate = NSDate()
        createEventDatePicker.minimumDate = currentDate
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        //Keyboard up at start
        createEventNameTF.becomeFirstResponder()
        
        //MARK: Customize Nav Bar
        let createEventCancelBtn:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "createEventCancel")
        let createEventAddBtn:UIBarButtonItem = UIBarButtonItem(title: "Create", style: .Plain, target: self, action: "createEventCreate")
        self.navigationItem.setRightBarButtonItem(createEventAddBtn, animated: true)
        self.navigationItem.setLeftBarButtonItem(createEventCancelBtn, animated: true)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.title = "Create Event"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        //Delegate Text Fields/Pickers
        createEventDateTF.delegate = self
        createEventDatePicker.hidden = true
        createEventTV.delegate = self
        eventDescriptionCount.text = "200"
        //self.signUpSchoolPicker.delegate = self
        //self.signUpSchoolPicker.dataSource = self
        
        //Taps to close
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    //DID RECIEVE MEMORY WARNING
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Go Back Function
    func createEventCancel() {
        if let navController = self.navigationController {
            self.tabBarController?.tabBar.hidden = false
            navController.popViewControllerAnimated(true)
        }
    }
    
    //Bring Up Editor on Text Field Tap
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        view.endEditing(true)
        createEventDatePicker.hidden = false
        return false
    }

    //Create Event Function
    func createEventCreate() {
        var currentUser = PFUser.currentUser()
        var username = currentUser!.username!
        var dateFormatter = NSDateFormatter()
        var calander = NSCalendar.currentCalendar()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        var event = PFObject(className: "Event")
        event["name"] = createEventNameTF.text
        event["creator"] = currentUser!.username
        event["dateAndTime"] = createEventDatePicker.date
        event["dateAndTimeString"] = createEventDateTF.text
        event["school"] = currentUser!.objectForKey("school")
        event["location"] = createEventLocationTF.text
        event["reportNumber"] = 0
        event["reported"] = false
        event["attending"] = [String(username)]
        var randomCode = randomNumber()
        event["pushCode"] = randomCode
        var randomCodeOwner = randomNumber()
        event["pushCodeOwner"] = randomCodeOwner
        event["warningSent"] = false
        
        
        var createEvent = EventCreate(event: createEventNameTF.text!, location: createEventLocationTF.text!, date: createEventDatePicker.date)
        
        do {
            try createEvent.eventAlert()
            
            //MARK: Save Event
            event.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if error == nil {
                    print("Yp")
                    // Success, no creating error.
                    currentUser!.incrementKey("points", byAmount: 5)
                    print(currentUser!.objectForKey("points"))
                    self.tabBarController?.tabBar.hidden = false
                    PFUser.currentUser()!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                        if error == nil {
                            print("Points Updated")
                        } else {
                            print("Error")
                        }
                    }
                    let currentInstallation = PFInstallation.currentInstallation()
                    currentInstallation.addUniqueObject(randomCodeOwner, forKey: "channels")
                    currentInstallation.saveInBackground()
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    print("Error")
                }
            } // Error Caught Alert Settings
        } catch let message as ErrorType {
            
            let alert = UIAlertController(title: "Uh-Oh!", message: "\(message)", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }

        
        }
    
    //MARK: Tap Function
    func dismissKeyboard() {
        //Causes view/text field to resign to first responder.
        view.endEditing(true)
    }
    
    //Live Count Text View
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText string: String) -> Bool {
        let newLength = (createEventTV.text?.characters.count)! + string.characters.count - range.length
        if(newLength <= 200){
            eventDescriptionCount.text = "\(200 - newLength)"
            return true
        }else{
            return false
        }
    }
    func textViewDidBeginEditing(textView: UITextView) {
        if createEventTV.text == "Tell us what's happening at the event."
        {
            createEventTV.text = ""
            createEventTV.textColor = UIColor.blackColor()
        }
    }
    
    func randomNumber() -> String{
        let alphabet =  "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" as NSString
        var i = 10
        var randomString = "C"
        while (i > 0){
            var num = arc4random_uniform(10)
            var alphanum = Int(arc4random_uniform(52))
            var letter = alphabet.substringWithRange(NSRange(location: alphanum, length: 1))
            randomString = randomString + letter
            randomString = randomString + String(num)
            i = i - 1
        }
        return randomString
    }


}
