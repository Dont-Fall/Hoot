//
//  QuestionAnswerViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/11/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class QuestionAnswerViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet var questionAnswerCountLablel: UILabel!
    @IBOutlet var questionAnswerAnswerTV: UITextView!
    @IBOutlet var questionAnswerPicPreview: UIImageView!
    @IBOutlet var questionAnswerAnswerCount: UILabel!

    @IBAction func questionAnswerAddPicBtn(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
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
        questionAnswerPicPreview.image = image; self.dismissViewControllerAnimated(true, completion: nil)
    }


    // Container to store the view table selected object
    var questionID : String?
    var asker : String?
    var currentObject: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        questionAnswerPicPreview.layer.cornerRadius = 8.0
        questionAnswerPicPreview.clipsToBounds = true
        // Do any additional setup after loading the view.
        
        //Keyboard up at start
        questionAnswerAnswerTV.becomeFirstResponder()
        //Live Count Delegate
        self.questionAnswerAnswerCount.text = "200"
        self.questionAnswerAnswerTV.delegate = self
        
        questionAnswerAnswerTV.textInputView.needsUpdateConstraints()
        questionAnswerAnswerTV.textInputView.sizeToFit()
        
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
        //questionAnswerAnswerTV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    //Go Back Function
    func answerQuestionCancel() {
        //questionAnswerAnswerTV.removeObserver(self, forKeyPath: "contentSize")
        navigationController?.popViewControllerAnimated(true)
    }
    
    /*override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        //let textView = object as! UITextView
        var topCorrect = (questionAnswerAnswerTV.bounds.size.height - questionAnswerAnswerTV.contentSize.height * questionAnswerAnswerTV.zoomScale) / 2
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect;
        questionAnswerAnswerTV.contentInset.top = topCorrect
    }*/
    
    //Answer Question FUnction
    func answerQuestionAnswerQuestion() {
        let currentUser = PFUser.currentUser()
        let answer = PFObject(className: "Answer")
        answer["answer"] = questionAnswerAnswerTV.text
        answer["user"] = currentUser!.username
        answer["correct"] = false
        answer["idNumber"] = questionID
        answer["askedBy"] = asker
        answer["reportNumber"] = 0
        answer["reported"] = false
        answer["hasPic"] = true
        let randomCode = randomNumber()
        answer["pushCode"] = randomCode
        answer["courseTag"] = currentObject?["course"]
        
        //PIC
        let questionAnswer = QuestionAnswer(text: questionAnswerAnswerTV.text!)
        if questionAnswerPicPreview.image != nil{
            answer["hasPic"] = true
            let imageData = UIImageJPEGRepresentation(self.questionAnswerPicPreview.image!,0.5)
            let imageFile = PFFile(name:"image.jpeg", data:imageData!)
            answer.setObject(imageFile!, forKey: "picture")
        }else{
            answer["hasPic"] = false
        }
        do {
            try questionAnswer.questionAnswerAlert()
            //MARK: Save Question
            answer.saveInBackgroundWithBlock { (success: Bool, error:   NSError?) -> Void in
                if error == nil {
                    // Success, no creating error
                    currentUser!.incrementKey("points", byAmount: 5)
                    currentUser!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                        if error == nil {
                            //Points Saved
                        } else {
                            //Not Saved
                        }
                    }
                    self.currentObject?.incrementKey("answerCount")
                    self.currentObject?.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                        if error == nil {
                            //Answer Saved
                        } else {
                            //Not Saved
                        }
                    }
                    let currentInstallation = PFInstallation.currentInstallation()
                    currentInstallation.addUniqueObject(randomCode, forKey: "channels")
                    currentInstallation.saveInBackground()
                    let push = PFPush()
                    push.setChannel(String(self.currentObject!["pushCode"]))
                    push.setMessage("Someone has answered your question for course '\(self.currentObject!["course"])'!")
                    push.sendPushInBackground()
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    //Not Saved
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
        let newLength = (questionAnswerAnswerTV.text?.characters.count)! + string.characters.count - range.length
        if(newLength <= 200){
            questionAnswerCountLablel.text = "\(200 - newLength)"
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
            let num = arc4random_uniform(10)
            let alphanum = Int(arc4random_uniform(52))
            let letter = alphabet.substringWithRange(NSRange(location: alphanum, length: 1))
            randomString = randomString + letter
            randomString = randomString + String(num)
            i = i - 1
        }
        return randomString
    }
}

