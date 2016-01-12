//
//  QuestionDetailAnswerSelectedViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/12/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class QuestionDetailAnswerSelectedViewController: UIViewController {
    
    //MARK: Extras
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150))
    var didReport = false
    
    //MARK: Label
    @IBOutlet var questionAnswerSelectedUserLabel: UILabel!
    //MARK: TV
    @IBOutlet var questionAnswerSelectedAnswerTV: UITextView!
    //MARK: Pic
    @IBOutlet var questionAnswerSelectedPicPreview: UIImageView!
    let tapRec = UITapGestureRecognizer()
    
    //MARK: Button
    @IBAction func questionDetailSelectedCorrectBtn(sender: AnyObject) {
        currentObject!["correct"] = true
        currentObject!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if error == nil {
                print("Answer Updated")
            } else {
                print("Error")
            }
        }
        var query = PFQuery(className:"Question")
        query.whereKey("objectId", equalTo: currentObject!["idNumber"])
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        object["solved"] = true
                        object.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                            if error == nil {
                                print("Question Updated")
                            } else {
                                print("Error")
                            }
                        }
                        
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    @IBOutlet var questionDetailSelectedCorrectBtn: UIButton!
    
    //MARK: User Correct
    var askedBy : String?
    var currentUser = PFUser.currentUser()
    
    
    // Container to store the view table selected object
    var currentObject : PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Unwrap the current object object
        if let object = currentObject {
            
            let userImageFile = object["picture"] as! PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        self.questionAnswerSelectedPicPreview.image = image
                    }
                }
            }
            
            questionAnswerSelectedUserLabel.text = object["user"] as! String
            questionAnswerSelectedAnswerTV.text = object["answer"] as! String
            askedBy = object["askedBy"] as! String
        }
        
        //MARK: Nav Bar Customize
        navigationController!.navigationBar.barTintColor = UIColor(red: 102.0 / 255.0, green: 204.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
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
        questionAnswerSelectedPicPreview.userInteractionEnabled = true
        tapRec.addTarget(self, action: "tapView")
        questionAnswerSelectedPicPreview.addGestureRecognizer(tapRec)
        
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
                    print("Error")
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
        if segue.identifier == "anwerShowPic" {
            // Get the new view controller using [segue destinationViewController].
            var detailScene = segue.destinationViewController as! QuestionPicViewController
            // Pass the selected object to the destination view controller.
            detailScene.largePic = questionAnswerSelectedPicPreview.image
        }
        
    }
    
    //Pic View
    func tapView() {
        self.actInd.startAnimating()
        self.performSegueWithIdentifier("anwerShowPic", sender: self)
        self.actInd.stopAnimating()
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

