//
//  ClassQuestionPicViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/7/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class ClassQuestionPicViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var zoomScrollView: UIScrollView!
    //MARK: Pic
    var largePic: UIImage!
    @IBOutlet var classQuestionLargeView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        //MARK: Nav Bar Customize
        let questionPicBackBtn:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "questionPicBack")
        self.navigationItem.setLeftBarButtonItem(questionPicBackBtn, animated: true)
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBarHidden = true
        self.navigationController?.hidesBarsOnTap = true
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController!.navigationBar.barTintColor = UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.0)
        classQuestionLargeView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Unwrap the current object object
        if let newPic = largePic {
            
            classQuestionLargeView.image = newPic
        }
        //Zoom
        self.zoomScrollView.minimumZoomScale = 1.0
        self.zoomScrollView.maximumZoomScale = 6.0
    }
    
    //Go Back Function
    func questionPicBack() {
        navigationController?.popViewControllerAnimated(true)
        //Set Back To Defaults
        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.navigationBarHidden = false
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
        self.navigationController?.navigationBar.shadowImage = .None
        self.navigationController?.navigationBar.setBackgroundImage(.None, forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.hidesBarsOnTap = false
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Zoom Function
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return self.classQuestionLargeView
    }

}
