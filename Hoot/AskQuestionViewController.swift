//
//  AskQuestionViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/2/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class AskQuestionViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate  {
    
    var askQuestionCancelBtn:UIBarButtonItem = UIBarButtonItem()
    var askQuestionAskBtn:UIBarButtonItem = UIBarButtonItem()
    
    //MARK: Picture
    @IBOutlet var askQuestionPicPreview: UIImageView!
    
    //MARK: Add Picture
    @IBAction func askQuestionAddPicBtn(sender: AnyObject) {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            imagePicker.sourceType = .Camera
            if (UIImagePickerController.isCameraDeviceAvailable(.Front)) { imagePicker.cameraDevice = .Front
            }else{
                imagePicker.cameraDevice = .Rear
            }
            
        }else{
            imagePicker.sourceType = .PhotoLibrary
        }
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
                askQuestionPicPreview.image = image; self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Extras
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150))
    
    //MARK: Text Felds
    @IBOutlet var askQuestionCourseTF: UITextField!
    
    //MARK: Text Views
    @IBOutlet var askQuestionAskQuestionTV: UITextView!
    
    
    //MARK: Labels
    @IBOutlet var askQuestionQuestionPlaceholder: UILabel!
    @IBOutlet var askQuestionCountLabel: UILabel!
    @IBOutlet var askQuestionCourseCountLabel: UILabel!
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        askQuestionPicPreview.layer.cornerRadius = 8.0
        askQuestionPicPreview.clipsToBounds = true
        // Do any additional setup after loading the view.
        
        //Keyboard up at start
        askQuestionCourseTF.becomeFirstResponder()
        
        //Live Count Delegate
        self.askQuestionCountLabel.text = "200"
        self.askQuestionAskQuestionTV.delegate = self
        self.askQuestionCourseCountLabel.text = "20"
        self.askQuestionCourseTF.delegate = self
        
        askQuestionAskQuestionTV.textInputView.needsUpdateConstraints()
        askQuestionAskQuestionTV.textInputView.sizeToFit()
        
        //MARK: Nav Bar Customize
        askQuestionCancelBtn = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "askQuestionCancel")
        askQuestionAskBtn = UIBarButtonItem(title: "Ask", style: .Plain, target: self, action: "askQuestionAskQuestion")
        self.navigationItem.setRightBarButtonItem(askQuestionAskBtn, animated: true)
        self.navigationItem.setLeftBarButtonItem(askQuestionCancelBtn, animated: true)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        askQuestionAskBtn.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.grayColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        askQuestionAskBtn.tintColor = UIColor.orangeColor()
        self.title = "Ask Question"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        //Ask Button Activation
        askQuestionAskBtn.enabled = true
        
        //Start TV at Top Left
        askQuestionAskQuestionTV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    //DID RECIEVE MEMORY WARNING
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
    }
    
    //Go Back Function
    func askQuestionCancel() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        //let textView = object as! UITextView
        var topCorrect = (askQuestionAskQuestionTV.bounds.size.height - askQuestionAskQuestionTV.contentSize.height * askQuestionAskQuestionTV.zoomScale) / 2
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect;
        askQuestionAskQuestionTV.contentInset.top = topCorrect
    }
    
    //Ask Function Question
    func askQuestionAskQuestion() {
        var currentUser = PFUser.currentUser()
        var question = PFObject(className: "Question")
        question["course"] = askQuestionCourseTF.text
        question["question"] = askQuestionAskQuestionTV.text
        question["user"] = currentUser!.username
        question["solved"] = false
        question["school"] = currentUser!.objectForKey("school")
        question["subject"] = currentUser!.objectForKey("subject")
        question["reportNumber"] = 0
        question["reported"] = false
        //PIC
        let imageData = UIImageJPEGRepresentation(self.askQuestionPicPreview.image!,0.5)
        let imageFile = PFFile(name:"image.jpeg", data:imageData!)
        question.setObject(imageFile!, forKey: "picture")
        //MARK: Save Question
        question.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if error == nil {
                print("Yp")
                // Success, no creating error
                currentUser!.incrementKey("points", byAmount: 5)
                currentUser!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if error == nil {
                        print("Points Updated")
                    } else {
                        print("Error")
                    }
                }
                self.actInd.startAnimating()
                self.performSegueWithIdentifier("askQuestionAskedSegue", sender: self)
                self.actInd.startAnimating()
            } else {
                print("Error")
            }
        }
    }
    
    //Live Count Text Field
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //Ask Enabled
        //Count Function
            let newLength = (askQuestionCourseTF.text?.characters.count)! + string.characters.count - range.length
            if(newLength <= 20){
                self.askQuestionCourseCountLabel.text = "\(20 - newLength)"
                return true
            }else{
                return false
            }
    }
    
    //Live Count Text View
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText string: String) -> Bool {
        let newLength = (askQuestionAskQuestionTV.text?.characters.count)! + string.characters.count - range.length
        if(newLength <= 200){
            askQuestionCountLabel.text = "\(200 - newLength)"
            return true
        }else{
            return false
        }
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
