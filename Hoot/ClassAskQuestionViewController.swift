//
//  ClassAskQuestionViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/7/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class ClassAskQuestionViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Extras
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150))
    
    //Text Fields
    @IBOutlet var classAskQuestionCourseTF: UITextField!
    @IBOutlet var classAskQuestionTV: UITextView!
    
    //Labels
    @IBOutlet var classAskQuestionCourseCount: UILabel!
    @IBOutlet var askQuestionQuestionCount: UILabel!
    
    var className: String?
    
    //Picture Preview
    @IBOutlet var classAskQuestionPicPreview: UIImageView!
    //Add Picture Button
    @IBAction func classAskQuestionAddPicBtn(sender: AnyObject) {
        var imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
            if (UIImagePickerController.isCameraDeviceAvailable(.Rear)) { imagePicker.cameraDevice = .Rear
            }else{
                imagePicker.cameraDevice = .Front
            }
        }else{
            imagePicker.sourceType = .PhotoLibrary
        }
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!){
        classAskQuestionPicPreview.image = image; self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        //Pic
        classAskQuestionPicPreview.layer.cornerRadius = 8.0
        classAskQuestionPicPreview.clipsToBounds = true

        //Keyboard up at start
        classAskQuestionCourseTF.becomeFirstResponder()
        
        //Live Count Delegate
        self.askQuestionQuestionCount.text = "200"
        self.classAskQuestionTV.delegate = self
        self.classAskQuestionCourseCount.text = "20"
        self.classAskQuestionCourseTF.delegate = self
        
        //MARK: Nav Bar Customize
        let askQuestionCancelBtn:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "classAskQuestionCancel")
        let askQuestionAskBtn:UIBarButtonItem = UIBarButtonItem(title: "Ask", style: .Plain, target: self, action: "classAskQuestionAskQuestion")
        self.navigationItem.setRightBarButtonItem(askQuestionAskBtn, animated: true)
        self.navigationItem.setLeftBarButtonItem(askQuestionCancelBtn, animated: true)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.title = "Ask Question"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    //Ask Function Question
    func classAskQuestionAskQuestion() {
        var currentUser = PFUser.currentUser()
        var classQuestion = PFObject(className: "ClassQuestion")
        classQuestion["question"] = classAskQuestionTV.text
        classQuestion["user"] = currentUser!.username
        classQuestion["solved"] = false
        classQuestion["topic"] = classAskQuestionCourseTF.text
        classQuestion["school"] = currentUser!.objectForKey("school")
        classQuestion["code"] = currentUser!.objectForKey("currentGroupCode")
        classQuestion["classNameTag"] = className
        classQuestion["reportNumber"] = 0
        classQuestion["reported"] = false
        classQuestion["answerCount"] = 0
        classQuestion["hasPic"] = true
        var randomCode = randomNumber()
        classQuestion["pushCode"] = randomCode
        
        if classAskQuestionPicPreview.image != nil{
            classQuestion["hasPic"] = true
            let imageData = UIImageJPEGRepresentation(self.classAskQuestionPicPreview.image!,0.5)
            let imageFile = PFFile(name:"image.jpeg", data:imageData!)
            classQuestion.setObject(imageFile!, forKey: "picture")
        
            var image: PFFile = imageFile!
            var classAskQuestionWithPic = ClassAskQuestionWithPic(topic: classAskQuestionCourseTF.text!, text: classAskQuestionTV.text!, img: image)
            do {
                try classAskQuestionWithPic.classAskQuestionAlert()
                //MARK: Save Question
                classQuestion.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if error == nil {
                        print("Yp")
                        // Success, no creating error.
                        currentUser!.incrementKey("points", byAmount: 5)
                        currentUser!.incrementKey("tokens", byAmount: -1)
                        currentUser!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                            if error == nil {
                                print("Points Updated")
                            } else {
                                print("Error")
                            }
                        }
                        let currentInstallation = PFInstallation.currentInstallation()
                        currentInstallation.addUniqueObject(randomCode, forKey: "channels")
                        currentInstallation.saveInBackground()
                        self.navigationController?.popViewControllerAnimated(true)
                    }else {
                    }
                }
            //Error Caught Alert Settings
            }catch let message as ErrorType {
                let alert = UIAlertController(title: "Uh-Oh!", message: "\(message)", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
            }
        }else{
            classQuestion["hasPic"] = false
            var classAskQuestion = ClassAskQuestion(topic: classAskQuestionCourseTF.text!, text: classAskQuestionTV.text!)
            
            do {
                try classAskQuestion.classAskQuestionAlert()
                //MARK: Save Question
                classQuestion.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if error == nil {
                        print("Yp")
                        // Success, no creating error.
                        currentUser!.incrementKey("tokens", byAmount: -1)
                        currentUser!.incrementKey("points", byAmount: 5)
                        currentUser!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                            if error == nil {
                                print("Points Updated")
                            } else {
                                print("Error")
                            }
                        }
                        let currentInstallation = PFInstallation.currentInstallation()
                        currentInstallation.addUniqueObject(randomCode, forKey: "channels")
                        currentInstallation.saveInBackground()
                        self.navigationController?.popViewControllerAnimated(true)
                    }else {
                        
                    }
                }
            // Error Caught Alert Settings
            }catch let message as ErrorType {
            
            let alert = UIAlertController(title: "Uh-Oh!", message: "\(message)", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
        }
    }
    
    //Go Back Function
    func classAskQuestionCancel() {
            navigationController?.popViewControllerAnimated(true)
    }
    
    //Live Count Text Field
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //Ask Enabled
        //Count Function
        let newLength = (classAskQuestionCourseTF.text?.characters.count)! + string.characters.count - range.length
        if(newLength <= 20){
            self.classAskQuestionCourseCount.text = "\(20 - newLength)"
            return true
        }else{
            return false
        }
    }
    
    //Live Count Text View
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText string: String) -> Bool {
        let newLength = (classAskQuestionTV.text?.characters.count)! + string.characters.count - range.length
        if(newLength <= 200){
            askQuestionQuestionCount.text = "\(200 - newLength)"
            return true
        }else{
            return false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if classAskQuestionTV.text == "What are you having trouble with?"
        {
            classAskQuestionTV.text = ""
            classAskQuestionTV.textColor = UIColor.blackColor()
        }
    }
    
    func randomNumber() -> String{
        let alphabet =  "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" as NSString
        var i = 10
        var randomString = "C"
        while (i > 0){
            var num = arc4random_uniform(10)
            var alphanum = Int(arc4random_uniform(52))
            var letter = alphabet.substringWithRange(NSRange(location: alphanum, length: 1))
            randomString = randomString + letter
            randomString = randomString + String(num)
            i = i - 1
        }
        return randomString
    }
    
}
