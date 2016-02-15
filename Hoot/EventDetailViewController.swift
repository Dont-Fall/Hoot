//
//  EventDetailViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/6/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    //MARK: Labels
    @IBOutlet var eventDetailCreatedBy: UILabel!
    @IBOutlet var eventDetailEventName: UILabel!
    @IBOutlet var eventDetailEventLocation: UILabel!
    @IBOutlet var eventDetailEventDate: UILabel!
    @IBOutlet var eventDetailAttendingCount: UILabel!
    @IBOutlet var eventDetailDescriptionTV: UITextView!
    
    // Container to store the view table selected object
    var currentObject : PFObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        //MARK: Hide Tab Bar
        self.tabBarController?.tabBar.hidden = true
        if String(currentObject!["creator"]) == (PFUser.currentUser()?.username)!{
            let detailedQuestionDeleteBtn:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "detailedQuestionDelete")
            self.navigationItem.setRightBarButtonItem(detailedQuestionDeleteBtn, animated: true)
        }else{
            let detailedQuestionReportBtn:UIBarButtonItem = UIBarButtonItem(title: "Report", style: .Plain, target: self, action: "detailedQuestionReport")
            self.navigationItem.setRightBarButtonItem(detailedQuestionReportBtn, animated: true)
        }
        //MARK: Nav Bar Customize
        navigationController!.navigationBar.barTintColor = UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
        let detailedQuestionBackBtn:UIBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "detailEventBack")
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.navigationItem.setLeftBarButtonItem(detailedQuestionBackBtn, animated: true)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.title = "Details"
        
        // Unwrap the current object object
        if let object = currentObject {
            eventDetailCreatedBy.text = "Created By: \(object["creator"] as! String)"
            eventDetailEventName.text = String(object["name"]) // as! String
            eventDetailEventDate.text = String(object["dateAndTimeString"]) // as! String
            eventDetailEventLocation.text = String(object["location"]) //as! String
            if let attending = object["attending"] as? Array<String> {
            eventDetailAttendingCount.text = "\(String(attending.count)) Attending"
            }
            eventDetailDescriptionTV.text = String(object["description"])
            
        }
    }
    
    //DID RECIEVE MEMORY WARNING
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Report Event Function
    func detailEventReport() {
        currentObject?.incrementKey("reportNumber")
        if (currentObject?["reportNumber"])! as! Int == 5 {
            currentObject?["reported"] = true
        }
        currentObject?.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if error == nil {
                // Success, no creating error.
            } else {
                //"Error"
            }
        }
    }
    
    //Go Back Function
    func detailEventBack(){
        if let navController = self.navigationController {
            self.tabBarController?.tabBar.hidden = false
            navController.popViewControllerAnimated(true)
        }
    }

    @IBAction func eventDetailAttendBtn(sender: AnyObject) {
        let user = PFUser.currentUser()
        var list = currentObject!["attending"] as! Array<String>
        if currentObject!["attending"].containsObject((user?.username)!) == true{
            let alert = UIAlertController(title: "Already Attending", message: "You've already signed up for this event.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }else{
            list.append((user?.username)!)
            currentObject!["attending"] = list
            currentObject!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if error == nil {
                    let alert = UIAlertController(title: "Signed Up", message: "Can't wait to see you there!", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    let currentInstallation = PFInstallation.currentInstallation()
                    currentInstallation.addUniqueObject(self.currentObject!["pushCode"], forKey: "channels")
                    currentInstallation.saveInBackground()
                    let push = PFPush()
                    push.setChannel(String(self.currentObject!["pushCodeOwner"]))
                    push.setMessage("Someone has signed up for your event '\(self.currentObject!["name"])'!")
                    push.sendPushInBackground()
                    if let attending = self.currentObject!["attending"] as? Array<String>{
                        self.eventDetailAttendingCount.text = "\(String(attending.count)) Attending"
                    }
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    //"Error"
                }
            }
        }
    }
    
    func detailedQuestionDelete(){
        let eventToDelete = currentObject
        confirmDelete(eventToDelete!)
    }
    func confirmDelete(Class : PFObject) {
        
        let alert = UIAlertController(title: "Delete Event", message: "Are you sure you want to delete this event?", preferredStyle: .ActionSheet)
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeleteEvent)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteEvent)
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func handleDeleteEvent(alertAction: UIAlertAction!) -> Void {
        currentObject?.deleteInBackground()
        navigationController?.popViewControllerAnimated(true)
        //navigationController?.popViewControllerAnimated(true)
    }
    
    func cancelDeleteEvent(alertAction: UIAlertAction!) {
        //Nothing
    }
    

}
