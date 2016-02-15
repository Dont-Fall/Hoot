//
//  ClassQuestionAnswerSelectedViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/13/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class ClassQuestionAnswerSelectedViewController: UIViewController {
    
    //MARK: Extras
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150))
    var didReport = false
    var questionObject: PFObject!
    
    //MARK: Label
    @IBOutlet var classQuestionAnswerSelectedUserLabel: UILabel!
    //MARK: TV
    @IBOutlet var classQuestionAnswerSelectedAnswerTV: UITextView!
    //MARK: Pic
    @IBOutlet var classQuestionAnswerSelectedPicPreview: UIImageView!
    let tapRec = UITapGestureRecognizer()
    
    //MARK: Button
    @IBAction func classQuestionDetailSelectedCorrectBtn(sender: AnyObject) {
        currentObject!["correct"] = true
        currentObject!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if error == nil {
                let push = PFPush()
                push.setChannel(String(self.currentObject!["pushCode"]))
                push.setMessage("Someone has marked your answer correct in class '\(self.currentObject!["classNameTag"])'!")
                push.sendPushInBackground()
            } else {
                //"Error"
            }
        }
        questionObject["solved"] = true
        questionObject.saveInBackground()
        
    }
    @IBOutlet var questionDetailSelectedCorrectBtn: UIButton!
    
    //MARK: User Correct
    var askedBy : String?
    var currentUser = PFUser.currentUser()
    
    
    // Container to store the view table selected object
    var currentObject : PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        // Unwrap the current object object
        if let object = currentObject {
            
            if object["hasPic"].boolValue == true{
                let userImageFile = object["picture"] as! PFFile
                userImageFile.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            let image = UIImage(data:imageData)
                            self.classQuestionAnswerSelectedPicPreview.image = image
                        }
                    }
                }
            }else{
                self.classQuestionAnswerSelectedPicPreview.hidden = true
            }
            classQuestionAnswerSelectedUserLabel.text = "Answered By: \(object["user"] as! String)"
            classQuestionAnswerSelectedAnswerTV.text = object["answer"] as! String
            askedBy = object["askedBy"] as! String
        }
        
        //MARK: Nav Bar Customize
        navigationController!.navigationBar.barTintColor = UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
        let detailedAnsweReportBtn:UIBarButtonItem = UIBarButtonItem(title: "Report", style: .Plain, target: self, action: "detailedAnswerReport")
        let detailedAnswerBackBtn:UIBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "detailedAnswerBack")
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.navigationItem.setRightBarButtonItem(detailedAnsweReportBtn, animated: true)
        self.navigationItem.setLeftBarButtonItem(detailedAnswerBackBtn, animated: true)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.title = "Details"
        
        //Hide
        self.tabBarController?.tabBar.hidden = true
        
        //MARK: Tap Image
        classQuestionAnswerSelectedPicPreview.userInteractionEnabled = true
        tapRec.addTarget(self, action: "tapView")
        classQuestionAnswerSelectedPicPreview.addGestureRecognizer(tapRec)
        
        //Hide Correct Button
        if currentUser?.username != askedBy {
            questionDetailSelectedCorrectBtn.hidden = true
        }
    }
    
    //DID RECIEVE MEMORY WARNING
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Report Question Function
    func detailedAnswerReport() {
        currentObject?.incrementKey("reportNumber")
        if didReport == false {
            if (currentObject?["reportNumber"])! as! Int == 5 {
                currentObject?["reported"] = true
            }
            currentObject?.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if error == nil {
                    let alert = UIAlertController(title: "Question Reported", message:"Thank you for keeping the hoot community safe.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
                    self.presentViewController(alert, animated: true){}
                    self.didReport = true
                } else {
                    //"Error"
                }
            }
        }else{
            let alert = UIAlertController(title: "Already Reported", message:"You have already reported this question.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        }
    }
    
    //Go Back Function
    func detailedAnswerBack(){
        navigationController?.popViewControllerAnimated(true)
        //Set Back
        self.tabBarController?.tabBar.hidden = false
    }
    
    //Prepare For Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "classAnwerShowPic" {
            // Get the new view controller using [segue destinationViewController].
            let detailScene = segue.destinationViewController as! ClassQuestionPicViewController
            // Pass the selected object to the destination view controller.
            detailScene.largePic = classQuestionAnswerSelectedPicPreview.image
        }
        
    }
    
    //Pic View
    func tapView() {
        self.performSegueWithIdentifier("classAnwerShowPic", sender: self)
    }
    
    
}