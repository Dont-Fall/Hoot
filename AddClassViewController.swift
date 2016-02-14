//
//  AddClassViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/3/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class AddClassViewController: UIViewController {
    
    var joinClassClassName : String = ""
    var joinClassCourseName : String = ""
    var joinClassCreator : String = ""
    var alreadyMember = false

    
    //MARK: UI Text Fields
    @IBOutlet var addClassClassNameTF: UITextField!
    @IBOutlet var addClassCourseTF: UITextField!
    @IBOutlet var addClassClassCodeTF: UITextField!
    @IBOutlet var addClassJoinClassCodeTF: UITextField!
    
    //Join CLass Button
    @IBAction func addClassJoinClassBtn(sender: AnyObject) {
        var currentUser = PFUser.currentUser()
        var addClassQuery = PFQuery(className:"Classes")
        addClassQuery.whereKey("school", equalTo: currentUser!.objectForKey("school")!)
        addClassQuery.whereKey("code", equalTo: addClassJoinClassCodeTF.text!)
        addClassQuery.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                //Check To See If Already Member
                if let objects = objects {
                    for object in objects {
                        var memberList = object["members"] as! Array<String>
                        if memberList.contains((currentUser?.username)!){
                            self.alreadyMember = true
                        }else{
                            //not already member
                        }
                    }
                }
                //Class Exists, Not Member
                if objects!.count != 0 && self.alreadyMember == false {
                    var currentUser = PFUser.currentUser()
                    if let objects = objects{
                        for object in objects {
                            var list = object["members"] as! Array<String>
                            list.append((currentUser?.username)!)
                            object["members"] = list
                            object.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                                if error == nil {
                                    // Success, no creating error.
                                    self.navigationController?.popViewControllerAnimated(true)
                                }else {
                                    //Code Not Valid
                                    print("Error")
                                }
                            }
                        }
                    }
                //Class Exist, Member
                }else if objects!.count != 0 && self.alreadyMember == true{
                    let alert = UIAlertController(title: "Already A Member", message:"You are already a member of that group.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                    self.presentViewController(alert, animated: true){}
                //Class Does Not Exist
                }else{
                    let alert = UIAlertController(title: "No Class With Code", message:"Sorry, there does not seem to be a class with this code, please try again.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                    self.presentViewController(alert, animated: true){}
            }
        }else{
            // Log details of the failure
            print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        //Keyboard up at start
        addClassClassNameTF.becomeFirstResponder()
        
        //MARK: Customize Nav Bar
        let addClassCancelBtn:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "addClassCancel")
        let addClassCreateBtn:UIBarButtonItem = UIBarButtonItem(title: "Create", style: .Plain, target: self, action: "addClassAdd")
        self.navigationItem.setRightBarButtonItem(addClassCreateBtn, animated: true)
        self.navigationItem.setLeftBarButtonItem(addClassCancelBtn, animated: true)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.title = "Add Class"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        // Do any additional setup after loading the view.
    }
    
    func addClassCancel() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func addClassAdd(){
        //Assign New Class
        var currentUser = PFUser.currentUser()
        let newClass = PFObject(className: "Classes")
        newClass["course"] = addClassCourseTF.text
        newClass["name"] = addClassClassNameTF.text
        newClass["creator"] = currentUser!.username
        newClass["school"] = currentUser!.objectForKey("school")
        newClass["code"] = addClassClassCodeTF.text
        newClass["member"] = currentUser!.username
        newClass["members"] = [String(currentUser!.username!)]
        
        var newClassClass = AddClass(name: addClassClassNameTF?.text, course: addClassCourseTF?.text, code: addClassClassCodeTF?.text)
        
        do{
            try newClassClass.addClassAlert()
            
            //Query to See If Unique Code Exists At School
            var codeQuery = PFQuery(className:"Classes")
            codeQuery.whereKey("school", equalTo: currentUser!.objectForKey("school")!)
            codeQuery.whereKey("code", equalTo: addClassClassCodeTF.text!)
            codeQuery.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    // The find succeeded.
                    // Do something with the found objects
                    if let objects = objects {
                        if objects.count == 0 {
                            //No Other Class With Code
                            //MARK: Save Class
                            newClass.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                                if error == nil {
                                    print("Yp")
                                    // Success, no creating error.
                                    self.navigationController?.popViewControllerAnimated(true)
                                    //Add to que
                                } else {
                                    print("Error")
                                }
                            }
                        }else{
                            //Unique Code Exists, Alert User
                            print("Error, Class Code Already Exists")
                            //Delete Eventually
                            let alert = UIAlertController(title: "Signed Up", message: "Can't wait to see you there!", preferredStyle: .Alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }catch let message as ErrorType {
            let alert = UIAlertController(title: "Uh-Oh!", message: "\(message)", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
