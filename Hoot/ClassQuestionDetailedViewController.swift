//
//  ClassQuestionDetailedViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/7/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class ClassQuestionDetailedViewController: UIViewController {
    
    var testID = ""
    var didReport = false
    
    //MARK: Extras
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150))
    
    //Labels
    @IBOutlet var classQuestionDetailedUsernameLabel: UILabel!
    
    //Text Views
    @IBOutlet var classQuestionDetailedQuestionTV: UITextView!
    
    //Pictures
    @IBOutlet var classQuestionDetailedPicturePreview: UIImageView!
    let tapRec = UITapGestureRecognizer()
    
    //Buttons
    @IBAction func classQuestionAnswersBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("classQuestionAnswersSegue", sender: self)
    }
    @IBAction func classQuestionHelpBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("classQuestionHelpSegue", sender: self)
    }
    
    
    // Container to store the view table selected object
    var currentObject : PFObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        classQuestionDetailedPicturePreview.layer.cornerRadius = 25.0
        classQuestionDetailedPicturePreview.clipsToBounds = true
        //MARK: Nav Bar Customize
        navigationController!.navigationBar.barTintColor = UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
        if String(currentObject!["user"]) == (PFUser.currentUser()?.username)!{
            let detailedQuestionDeleteBtn:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "detailedClassQuestionDelete")
            self.navigationItem.setRightBarButtonItem(detailedQuestionDeleteBtn, animated: true)
        }else{
            let detailedQuestionReportBtn:UIBarButtonItem = UIBarButtonItem(title: "Report", style: .Plain, target: self, action: "detailedQuestionReport")
            self.navigationItem.setRightBarButtonItem(detailedQuestionReportBtn, animated: true)
        }
        let detailedQuestionBackBtn:UIBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "detailedQuestionBack")
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.navigationItem.setLeftBarButtonItem(detailedQuestionBackBtn, animated: true)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.title = "Details"
        
        // Unwrap the current object object
        if let object = currentObject {
            if object["hasPic"].boolValue == true{
                let userImageFile = object["picture"] as! PFFile
                userImageFile.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        self.classQuestionDetailedPicturePreview.image = image
                        }
                    }
                }
            }else{
            self.classQuestionDetailedPicturePreview.hidden = true
            }
    
            classQuestionDetailedUsernameLabel.text = "Asked By: \(object["user"] as! String)"
            classQuestionDetailedQuestionTV.text = object["question"] as! String
            testID = object.objectId!
    }
    
        //MARK: Tap Image
        classQuestionDetailedPicturePreview.userInteractionEnabled = true
        tapRec.addTarget(self, action: "tapView")
        classQuestionDetailedPicturePreview.addGestureRecognizer(tapRec)

        // Do any additional setup after loading the view.
    }
    
    //Report Question Function
    func detailedQuestionReport() {
        if didReport == false {
            currentObject?.incrementKey("reportNumber")
            if (currentObject?["reportNumber"])! as! Int == 5 {
                currentObject?["reported"] = true
            }
            currentObject?.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if error == nil {
                    let alert = UIAlertController(title: "Question Reported", message:"Thank you for keeping the Hoot community safe.", preferredStyle: .Alert)
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
    func detailedQuestionBack(){
        navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Prepare For Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "classQuestionShowPic" {
            // Get the new view controller using [segue destinationViewController].
            var detailScene = segue.destinationViewController as! ClassQuestionPicViewController
            // Pass the selected object to the destination view controller.
            detailScene.largePic = classQuestionDetailedPicturePreview.image
        }else if segue.identifier == "classQuestionHelpSegue"{
            var detailScene = segue.destinationViewController as! ClassQuestionAnswerViewController
            detailScene.questionID = testID
            detailScene.asker = classQuestionDetailedUsernameLabel.text
            detailScene.currentObject = currentObject
        }else if segue.identifier == "classQuestionAnswersSegue" {
            var detailScene = segue.destinationViewController as! ClassQuestionAnswersTableViewController
            detailScene.queryID = testID
    }
    }

    //Pic View
    func tapView() {
        self.actInd.startAnimating()
        self.performSegueWithIdentifier("classQuestionShowPic", sender: self)
        self.actInd.stopAnimating()
    }
    
    func detailedClassQuestionDelete(){
        let classQuestionToDelete = currentObject
        confirmDelete(classQuestionToDelete!)
    }
    
    func confirmDelete(Class : PFObject) {
        
        let alert = UIAlertController(title: "Delete Question", message: "Are you sure you want to delete this question?", preferredStyle: .ActionSheet)
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeleteClassQuestion)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteClassQuestion)
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func handleDeleteClassQuestion(alertAction: UIAlertAction!) -> Void {
        currentObject?.deleteInBackground()
        navigationController?.popViewControllerAnimated(true)
        //navigationController?.popViewControllerAnimated(true)
    }
    
    func cancelDeleteClassQuestion(alertAction: UIAlertAction!) {
    }
    
}
