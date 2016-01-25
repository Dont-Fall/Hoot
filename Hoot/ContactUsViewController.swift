//
//  ContactUsViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/18/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {

    @IBOutlet var contactUsTopicTF: UITextField!
    @IBOutlet var contactUsTextTV: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Nav Bar Customize
        let contactUsCancelBtn:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "contactUsCancel")
        let contactUsSubmitBtn:UIBarButtonItem = UIBarButtonItem(title: "Submit", style: .Plain, target: self, action: "contactUsSubmit")
        self.navigationItem.setRightBarButtonItem(contactUsSubmitBtn, animated: true)
        self.navigationItem.setLeftBarButtonItem(contactUsCancelBtn, animated: true)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.title = "Contact Us"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Go Back Function
    func contactUsCancel() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    //Submit Function
    func contactUsSubmit() {
        var currentUser = PFUser.currentUser()
        var contactForm = PFObject(className:"Contact")
        contactForm["topic"] = contactUsTopicTF.text
        contactForm["text"] = contactUsTextTV.text
        contactForm["UserSchool"] = currentUser?.objectForKey("school")
        contactForm["user"] = currentUser?.username
        contactForm["email"] = currentUser?.email
        contactForm["resolved"] = false
        contactForm.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                // There was a problem, check error.description
            }
        }
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
