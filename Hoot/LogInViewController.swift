//
//  LoginViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 12/30/15.
//  Copyright © 2015 Nitrox Development. All rights reserved.
//

import Foundation
import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Extras
//    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150))
    
    //MARK: Text Fields
    @IBOutlet var logInUserTF: UITextField!
    @IBOutlet var logInPasswordTF: UITextField!
    
    //MARK: Label
    @IBOutlet weak var errorLabel: UILabel!
    
    var testList = Array<String>()

    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .Default
        // Do any additional setup after loading the view, typically from a nib.
        // Creates the query
        let schoolQuery = PFQuery(className:"School")
        schoolQuery.whereKey("approved", equalTo: true)
        
        // Starts the download
        schoolQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) tasks.")
                
                // Do something with the found objects
                if let objects = objects{
                    for object in objects {
                        var school = object["name"]! as! String
                        self.testList.append(school)
                        print("Array: \(self.testList)")
                    }
                }
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        //TF Delegates
        logInUserTF.delegate = self
        logInPasswordTF.delegate = self
        
        //Taps to close
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        //Hide Nav Bar
        navigationController?.navigationBarHidden = true
        tabBarController?.tabBar.hidden = true
    }
    
    //DID RECIEVE MEMORY WARNING
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Tap Function
    func dismissKeyboard() {
        //Causes view/text field to resign to first responder.
        view.endEditing(true)
    }
    
    //MARK: Log In
    @IBAction func logInLogInBtn(sender: AnyObject) {
        errorLabel.text = ""
 /*       var user = PFUser()
        user.username = logInUserTF.text
        user.password = logInPasswordTF.text
        PFUser.logInWithUsernameInBackground(logInUserTF.text!, password: logInPasswordTF.text!, block: {
            (User : PFUser?, Error : NSError?) -> Void in
            if Error == nil{
                self.actInd.startAnimating()
                self.performSegueWithIdentifier("logIn", sender: self)
                self.actInd.stopAnimating()
            }else{
                print("Error")
            }
        })
*/
        let signin = SignIn(user: logInUserTF.text!, pass: logInPasswordTF.text!)
        
        do {
            try signin.signInUser()
            self.performSegueWithIdentifier("logIn", sender: self)
        }catch let error as Error {
            errorLabel.text = error.description
        } catch {
            errorLabel.text = "Sorry, something went\n wrong please try again."
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "signUp" {
            // Get the new view controller using [segue destinationViewController].
            var detailScene = segue.destinationViewController as! SignUpViewController
            // Pass the selected object to the destination view controller.
            detailScene.schoolListUnsorted = testList
        }
    }
    
    @IBAction func logInPasswordResetBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("forgotPasswordSegue", sender: self)
    }
    //Mark: Move to Sign Up
    @IBAction func logInSignUpBtn(sender: AnyObject) {
//        self.actInd.startAnimating()
        self.performSegueWithIdentifier("signUp", sender: self)
//        self.actInd.stopAnimating()
    }
}