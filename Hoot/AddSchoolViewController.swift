//
//  AddSchoolViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 2/3/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class AddSchoolViewController: UIViewController {
    
    //MARK: Outlet Connecitons
    @IBOutlet var addSchoolStateTF: UITextField!
    @IBOutlet var addSchoolSchoolTF: UITextField!

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
    @IBAction func addSchoolBackBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("addSchoolToSignUpSegue", sender: self)
    }
    
    @IBAction func addSchoolAddBtn(sender: AnyObject) {
        var school = PFObject(className:"School")
        school["name"] = addSchoolSchoolTF.text
        school["state"] = addSchoolStateTF.text
        school["approved"] = false
        school.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
    }
}
