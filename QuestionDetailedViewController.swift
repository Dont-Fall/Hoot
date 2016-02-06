//
//  QuestionDetailedViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/4/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class QuestionDetailedViewController: UIViewController, UITextViewDelegate {
    
    var testID = ""
    
    //MARK: Labels
    @IBOutlet var questionDetailedUsernameLabel: UILabel!
    @IBOutlet var questionDetailCourseLabel: UILabel!
    
    //MARK: Text Views
    @IBOutlet var questionDetailQuestionTV: UITextView!
    
    //MARK: Buttons
    @IBAction func questionDetailedAnswerBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("questionAnswerTableSegue", sender: self)
    }
    
    @IBAction func questionDetailedHelpBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("questionDetailHelpSegue", sender: self)
    }
    
    //MARK: Picture Preview
    @IBOutlet var questionDetailedPicturePreview: UIImageView!
    let tapRec = UITapGestureRecognizer()
    
    //MARK: Extras
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150))
    var didReport = false
    
    // Container to store the view table selected object
    var currentObject : PFObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        //Circle Edges on Pic
        questionDetailedPicturePreview.layer.cornerRadius = 8.0
        questionDetailedPicturePreview.clipsToBounds = true

        // Unwrap the current object object
        if let object = currentObject {
            
            let userImageFile = object["picture"] as! PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        self.questionDetailedPicturePreview.image = image
                    }
                }
            }
            
            questionDetailedUsernameLabel.text = "Asked By:\n     \(object["user"] as! String)"
            questionDetailCourseLabel.text = "For Course:\n     \(object["course"] as! String)"
            questionDetailQuestionTV.text = object["question"] as! String
            testID = object.objectId!
        }
        
        //MARK: Nav Bar Customize
        navigationController!.navigationBar.barTintColor = UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
        let detailedQuestionReportBtn:UIBarButtonItem = UIBarButtonItem(title: "Report", style: .Plain, target: self, action: "detailedQuestionReport")
        let detailedQuestionBackBtn:UIBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "detailedQuestionBack")
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.navigationItem.setRightBarButtonItem(detailedQuestionReportBtn, animated: true)
        self.navigationItem.setLeftBarButtonItem(detailedQuestionBackBtn, animated: true)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.title = "Details"

        //MARK: Tap Image
        questionDetailedPicturePreview.userInteractionEnabled = true
        tapRec.addTarget(self, action: "tapView")
        questionDetailedPicturePreview.addGestureRecognizer(tapRec)
    }
    
    //DID RECIEVE MEMORY WARNING
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Report Question Function
    func detailedQuestionReport() {
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
    func detailedQuestionBack(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    //Prepare For Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "questionShowPic" {
            // Get the new view controller using [segue destinationViewController].
            var detailScene = segue.destinationViewController as! QuestionPicViewController
            // Pass the selected object to the destination view controller.
            detailScene.largePic = questionDetailedPicturePreview.image
        }else if segue.identifier == "questionDetailHelpSegue"{
            var detailScene = segue.destinationViewController as! QuestionAnswerViewController
            detailScene.questionID = testID
            detailScene.asker = questionDetailedUsernameLabel.text
            //detailScene.currentObject = currentObject
        }else if segue.identifier == "questionAnswerTableSegue" {
            var detailScene = segue.destinationViewController as! QuestionDetailAnswerTableViewController
            detailScene.queryID = testID
        }

    }
    
    //Pic View
    func tapView() {
        self.actInd.startAnimating()
        self.performSegueWithIdentifier("questionShowPic", sender: self)
        self.actInd.stopAnimating()
    }

}
