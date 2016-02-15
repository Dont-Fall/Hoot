//
//  TermsViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 2/14/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {
    
    var state: String!
    var testList = Array<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(state)
        let schoolQuery = PFQuery(className:"School")
        schoolQuery.whereKey("approved", equalTo: true)
        schoolQuery.whereKey("state", equalTo: state)
        
        // Starts the download
        schoolQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                // Do something with the found objects.
                if let objects = objects{
                    for object in objects {
                        let school = object["name"]! as! String
                        self.testList.append(school)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func termsTermsBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("showTermsSegue", sender: self)
    }
    
    @IBAction func termsBackBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("termsAgreeBackSegue", sender: self)
    }
    
    @IBAction func termsAgreeBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("termsToSignUpSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "termsToSignUpSegue"{
            // Get the new view controller using [segue destinationViewController].
            let detailScene = segue.destinationViewController as! SignUpViewController
            // Pass the selected object to the destination view controller.
            detailScene.schoolListUnsorted = testList
        }else if segue.identifier == "showTermsSegue"{
            let detailScene = segue.destinationViewController as! TermsOfServiceViewController
            // Pass the selected object to the destination view controller.
            detailScene.state = state
        }
    }
}
