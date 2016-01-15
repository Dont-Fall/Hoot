//
//  CreateEventViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/3/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {
    
    //MARK: Text Fields
    @IBOutlet var createEventNameTF: UITextField!
    @IBOutlet var createEventDateTF: UITextField!
    @IBOutlet var createEventLocationTF: UITextField!
    
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
        
        var event = PFObject(className: "Event")
        event["name"] = createEventNameTF.text
        event["creator"] = currentUser!.username
        event["dateAndTime"] = createEventDateTF.text
        event["school"] = currentUser!.objectForKey("school")
        event["location"] = createEventLocationTF.text
        event["reportNumber"] = 0
        event["reported"] = false
        
        
        var createEvent = EventCreate(event: createEventNameTF.text!, location: createEventLocationTF.text!, date: createEventDateTF.text!)
        
        do {
            try createEvent.eventAlert()
            
            //MARK: Save Event
            event.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if error == nil {
                    print("Yp")
                    // Success, no creating error.
                    self.navigationController?.popViewControllerAnimated(true)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
