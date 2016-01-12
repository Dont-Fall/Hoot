//
//  QuestionPicViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/6/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class QuestionPicViewController: UIViewController {
    
    //MARK: Pic 
    var largePic: UIImage!
    @IBOutlet var questionPicLargeView: UIImageView!
    
    //MARK: Clear Pic

    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Nav Bar Customize
        let questionPicBackBtn:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "questionPicBack")
        self.navigationItem.setLeftBarButtonItem(questionPicBackBtn, animated: true)
        //UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBarHidden = true
        self.navigationController?.hidesBarsOnTap = true
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        questionPicLargeView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        // Unwrap the current object object
        if let newPic = largePic {
            
            questionPicLargeView.image = newPic
        }
    }
    
    //DID RECIEVE MEMORY WARNING
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Tap Function
    func dismissKeyboard() {
        //Causes view/text field to resign to first responder.
        
    }
    
    //Go Back Function
    func questionPicBack() {
        navigationController?.popViewControllerAnimated(true)
        //Set Back To Defaults
        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.navigationBarHidden = false
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 102.0 / 255.0, green: 204.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
        self.navigationController?.navigationBar.shadowImage = .None
        self.navigationController?.navigationBar.setBackgroundImage(.None, forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.hidesBarsOnTap = false
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
