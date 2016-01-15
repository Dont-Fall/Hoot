//
//  ClassAskQuestionViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/7/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class ClassAskQuestionViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Extras
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150))
    
    //Text Fields
    @IBOutlet var classAskQuestionCourseTF: UITextField!
    @IBOutlet var classAskQuestionQuestionTF: UITextField!
    //Labels
    @IBOutlet var classAskQuestionCourseCount: UILabel!
    @IBOutlet var askQuestionQuestionCount: UILabel!

    //Picture Preview
    @IBOutlet var classAskQuestionPicPreview: UIImageView!
    //Add Picture Button
    @IBAction func classAskQuestionAddPicBtn(sender: AnyObject) {
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
        classAskQuestionPicPreview.image = image; self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Pic
        classAskQuestionPicPreview.layer.cornerRadius = 8.0
        classAskQuestionPicPreview.clipsToBounds = true

        //Keyboard up at start
        classAskQuestionCourseTF.becomeFirstResponder()
        
        //Live Count Delegate
        self.askQuestionQuestionCount.text = "200"
        self.classAskQuestionQuestionTF.delegate = self
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

        // Do any additional setup after loading the view.
    }
    
    //Ask Function Question
    func classAskQuestionAskQuestion() {
        var currentUser = PFUser.currentUser()
        var classQuestion = PFObject(className: "ClassQuestion")
        classQuestion["question"] = classAskQuestionQuestionTF.text
        classQuestion["user"] = currentUser!.username
        classQuestion["solved"] = false
        classQuestion["school"] = currentUser!.objectForKey("school")
        classQuestion["code"] = currentUser!.objectForKey("currentGroupCode")
        classQuestion["reportNumber"] = 0
        classQuestion["reported"] = false
        //PIC
        let imageData = UIImageJPEGRepresentation(self.classAskQuestionPicPreview.image!,0.5)
        let imageFile = PFFile(name:"image.jpeg", data:imageData!)
        classQuestion.setObject(imageFile!, forKey: "picture")
        
        var image: PFFile = imageFile!
        var classAskQuestion = ClassAskQuestion(topic: classAskQuestionCourseTF.text!, text: classAskQuestionQuestionTF.text!, img: image)
        do {
            try classAskQuestion.classAskQuestionAlert()
            
            //MARK: Save Question
            classQuestion.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if error == nil {
                    print("Yp")
                    // Success, no creating error.
                    self.navigationController?.popViewControllerAnimated(true)
                    currentUser!.incrementKey("points", byAmount: 5)
                    currentUser!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                        if error == nil {
                            print("Points Updated")
                        } else {
                            print("Error")
                        }
                    }
                } else {
                }
            }
        // Error Caught Alert Settings
        }catch let message as ErrorType {
            
            let alert = UIAlertController(title: "Uh-Oh!", message: "\(message)", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    //Go Back Function
    func classAskQuestionCancel() {
            navigationController?.popViewControllerAnimated(true)
    }
    
    //Live Count Function
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
            switch textField {
        case self.classAskQuestionQuestionTF:
            let newLength = (classAskQuestionQuestionTF.text?.characters.count)! + string.characters.count - range.length
            if(newLength <= 200){
                self.askQuestionQuestionCount.text = "\(200 - newLength)"
                return true
            }else{
                return false
            }
        case self.classAskQuestionCourseTF:
            let newLength = (classAskQuestionCourseTF.text?.characters.count)! + string.characters.count - range.length
            if(newLength <= 20){
                self.classAskQuestionCourseCount.text = "\(20 - newLength)"
                return true
            }else{
                return false
            }
        default:
            return false
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
