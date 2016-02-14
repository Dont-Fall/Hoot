//
//  classQuestionAnswerViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/13/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class ClassQuestionAnswerViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet var classQuestionAnswerCountLablel: UILabel!
    @IBOutlet var classQuestionAnswerAnswerTV: UITextView!
    @IBOutlet var classQuestionAnswerPicPreview: UIImageView!
    @IBOutlet var classQuestionAnswerAnswerCount: UILabel!
    
    @IBAction func questionAnswerAddPicBtn(sender: AnyObject) {
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
        classQuestionAnswerPicPreview.image = image; self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // Container to store the view table selected object
    var questionID : String?
    var asker : String?
    var currentObject: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        classQuestionAnswerPicPreview.layer.cornerRadius = 8.0
        classQuestionAnswerPicPreview.clipsToBounds = true
        // Do any additional setup after loading the view.
        
        //Keyboard up at start
        classQuestionAnswerAnswerTV.becomeFirstResponder()
        
        //Live Count Delegate
        self.classQuestionAnswerAnswerCount.text = "200"
        self.classQuestionAnswerAnswerTV.delegate = self
        
        //classQuestionAnswerAnswerTV.textInputView.needsUpdateConstraints()
        //classQuestionAnswerAnswerTV.textInputView.sizeToFit()
        
        //MARK: Nav Bar Customize
        let answerQuestionCancelBtn = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "answerQuestionCancel")
        let answerQuestionAnswerBtn = UIBarButtonItem(title: "Answer", style: .Plain, target: self, action: "answerQuestionAnswerQuestion")
        self.navigationItem.setRightBarButtonItem(answerQuestionAnswerBtn, animated: true)
        self.navigationItem.setLeftBarButtonItem(answerQuestionCancelBtn, animated: true)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        answerQuestionAnswerBtn.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.title = "Answer Question"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        //Ask Button Activation
        answerQuestionAnswerBtn.enabled = true
        
        //Start TV at Top Left
        //classQuestionAnswerAnswerTV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Go Back Function
    func answerQuestionCancel() {
        //classQuestionAnswerAnswerTV.removeObserver(self, forKeyPath: "contentSize")
        navigationController?.popViewControllerAnimated(true)
    }
    
    //Answer Question FUnction
    func answerQuestionAnswerQuestion() {
        var currentUser = PFUser.currentUser()
        var answer = PFObject(className: "ClassAnswer")
        answer["answer"] = classQuestionAnswerAnswerTV.text
        answer["user"] = currentUser!.username
        answer["correct"] = false
        answer["idNumber"] = questionID
        answer["askedBy"] = asker
        answer["reportNumber"] = 0
        answer["reported"] = false
        answer["hasPic"] = true
        answer["classNameTag"] = currentObject?["classNameTag"]
        var randomCode = randomNumber()
        answer["pushCode"] = randomCode
        //PIC
        var classQuestionAnswer = ClassQuestionAnswer(text: classQuestionAnswerAnswerTV.text!)
        if classQuestionAnswerPicPreview.image != nil{
            answer["hasPic"] = true
            let imageData = UIImageJPEGRepresentation(self.classQuestionAnswerPicPreview.image!,0.5)
            let imageFile = PFFile(name:"image.jpeg", data:imageData!)
            answer.setObject(imageFile!, forKey: "picture")
        }else{
            answer["hasPic"] = false
        }
        do {
            try classQuestionAnswer.classQuestionAnswerAlert()
            //MARK: Save Question
            answer.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
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
                self.currentObject?.incrementKey("answerCount")
                self.currentObject?.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    if error == nil {
                        print("Answeres Updated")
                    } else {
                        print("Error")
                    }
                }
                let currentInstallation = PFInstallation.currentInstallation()
                currentInstallation.addUniqueObject(randomCode, forKey: "channels")
                currentInstallation.saveInBackground()
                let push = PFPush()
                push.setChannel(String(self.currentObject!["pushCode"]))
                push.setMessage("Someone has answered your question in class '\(self.currentObject!["classNameTag"])'!")
                push.sendPushInBackground()
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                print("Error")
            }
        }
        // Error Caught Alert Settings
    }catch let message as ErrorType {
        let alert = UIAlertController(title: "Uh-Oh!", message: "\(message)", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
        }
    }
    //Live Count Text View
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText string: String) -> Bool {
        let newLength = (classQuestionAnswerAnswerTV.text?.characters.count)! + string.characters.count - range.length
        if(newLength <= 200){
            classQuestionAnswerCountLablel.text = "\(200 - newLength)"
            return true
        }else{
            return false
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


