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

    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .Default
        
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
        
        let signin = SignIn(user: logInUserTF.text!, pass: logInPasswordTF.text!)
        
        do {
            try signin.signInUser()
            self.performSegueWithIdentifier("logIn", sender: self)
        }catch let error as Error {
            //dismissKeyboard()
            errorLabel.text = error.description
        } catch {
            errorLabel.text = "Sorry, something went\n wrong please try again."
        }
    }
    
    @IBAction func logInPasswordResetBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("forgotPasswordSegue", sender: self)
    }
    //Mark: Move to Sign Up
    @IBAction func logInSignUpBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("logInToStateSegue", sender: self)
    }
}