//
//  QuestionAnswerViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/11/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class QuestionAnswerViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet var questionAnswerAnswerTV: UITextView!
    @IBOutlet var questionAnswerPicPreview: UIImageView!
    @IBOutlet var questionAnswerAnswerCount: UILabel!

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
        questionAnswerPicPreview.image = image; self.dismissViewControllerAnimated(true, completion: nil)
    }


    // Container to store the view table selected object
    var questionID : String?
    var asker : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        questionAnswerAnswerTV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Go Back Function
    func answerQuestionCancel() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    //Answer Question FUnction
    func answerQuestionAnswerQuestion() {
        var currentUser = PFUser.currentUser()
        var answer = PFObject(className: "Answer")
        answer["answer"] = questionAnswerAnswerTV.text
        answer["user"] = currentUser!.username
        answer["correct"] = false
        answer["idNumber"] = questionID
        answer["askedBy"] = asker
        answer["reportNumber"] = 0
        answer["reported"] = false
        //PIC
        let imageData = UIImageJPEGRepresentation(self.questionAnswerPicPreview.image!,0.5)
        let imageFile = PFFile(name:"image.jpeg", data:imageData!)
        answer.setObject(imageFile!, forKey: "picture")
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
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                print("Error")
            }
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
