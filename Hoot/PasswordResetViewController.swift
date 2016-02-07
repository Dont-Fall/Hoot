//
//  PasswordResetViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 2/3/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class PasswordResetViewController: UIViewController {
    
    //MARK: Outlet Connections
    @IBOutlet var passwordResetEmailTF: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .Default
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Action Connections
    @IBAction func passwordResetBackBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("resetCancelSegue", sender: self)
    }
    
    @IBAction func passwordResetResetBtn(sender: AnyObject) {
        var passwordReset = PasswordReset(email: passwordResetEmailTF?.text)
        do{
            try passwordReset.passwordResetAlert()
            
            PFUser.requestPasswordResetForEmailInBackground(passwordResetEmailTF.text!)
            let alert = UIAlertController(title: "Password Reset", message: "You should recieve an email shortly with directions for changing your password.", preferredStyle: .Alert)
            var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.performSegueWithIdentifier("resetCancelSegue", sender: self)
            }
            alert.addAction(okAction)
            presentViewController(alert, animated: true, completion: nil)
        }catch let message as ErrorType {
            let alert = UIAlertController(title: "Uh-Oh!", message: "\(message)", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
}
