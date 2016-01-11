//
//  ClassQuestionDetailedViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/7/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ClassQuestionDetailedViewController: UIViewController {
    
    //MARK: Extras
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150))
    
    //Labels
    @IBOutlet var classQuestionDetailedUsernameLabel: UILabel!
    @IBOutlet var classQuestionDetailedQuestionLabel: UILabel!
    //Pictures
    @IBOutlet var classQuestionDetailedPicturePreview: UIImageView!
    let tapRec = UITapGestureRecognizer()
    
    // Container to store the view table selected object
    var currentObject : PFObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Nav Bar Customize
        navigationController!.navigationBar.barTintColor = UIColor(red: 102.0 / 255.0, green: 204.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
        let detailedQuestionReportBtn:UIBarButtonItem = UIBarButtonItem(title: "Report", style: .Plain, target: self, action: "detailedQuestionReport")
        let detailedQuestionBackBtn:UIBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "detailedQuestionBack")
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.navigationItem.setRightBarButtonItem(detailedQuestionReportBtn, animated: true)
        self.navigationItem.setLeftBarButtonItem(detailedQuestionBackBtn, animated: true)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.title = "Details"
        
        // Unwrap the current object object
        if let object = currentObject {
            
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
            
            classQuestionDetailedUsernameLabel.text = object["user"] as! String
            classQuestionDetailedQuestionLabel.text = object["question"] as! String
        }
        
        //MARK: Tap Image
        classQuestionDetailedPicturePreview.userInteractionEnabled = true
        tapRec.addTarget(self, action: "tapView")
        classQuestionDetailedPicturePreview.addGestureRecognizer(tapRec)

        // Do any additional setup after loading the view.
    }
    
    //Report Question Function
    func detailedQuestionReport() {
        currentObject?.incrementKey("reportNumber")
        if (currentObject?["reportNumber"])! as! Int == 5 {
            currentObject?["reported"] = true
        }
        currentObject?.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if error == nil {
                print("Yp")
                // Success, no creating error.
            } else {
                print("Error")
            }
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
        }
    }
    
    //Pic View
    func tapView() {
        self.actInd.startAnimating()
        self.performSegueWithIdentifier("classQuestionShowPic", sender: self)
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
