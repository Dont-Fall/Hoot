//
//  VerifyEmailViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 2/3/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class VerifyEmailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .Default
        self.navigationController?.navigationBarHidden = true
        self.tabBarController?.tabBar.hidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark: Actions Outlet
    @IBAction func verifiedBtn(sender: AnyObject) {
        var currentUser = PFUser.currentUser()
        do {
            try currentUser?.fetchInBackgroundWithBlock(nil)
        }catch{
            //nothing
        }
        var verifiedCheck = currentUser!["emailVerified"] as? Bool
        currentUser!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if error == nil {
                print(verifiedCheck)
                if verifiedCheck  == false {
                    let alert = UIAlertController(title: "Uh-Oh!", message: "You haven't verified your email yet!", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }else{
                    UIApplication.sharedApplication().statusBarStyle = .LightContent
                    self.navigationController?.navigationBarHidden = false
                    self.tabBarController?.tabBar.hidden = false
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }else{
            print("Error")
            }
        }
    }
    @IBAction func resendBtn(sender: AnyObject) {
        var currentUser = PFUser.currentUser()
        var savedEmail = currentUser?.email
        currentUser?.email = "temp@temp.temp"
        currentUser!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if error == nil {
                currentUser?.email = savedEmail
                currentUser!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if error == nil {
                        print("No Error")
                    } else {
                        print("Error")
                    }
                }
            } else {
                print("Error")
            }
        }
        let alert = UIAlertController(title: "Email Sent", message: "You should recieve another verificaiton email shortly.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    @IBAction func backBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("verifyToLogInSegue", sender: self)
    }

}
