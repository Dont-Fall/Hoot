//
//  EventDetailViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/6/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    //MARK: Labels
    @IBOutlet var eventDetailCreatedBy: UILabel!
    @IBOutlet var eventDetailEventName: UILabel!
    @IBOutlet var eventDetailEventLocation: UILabel!
    @IBOutlet var eventDetailEventDate: UILabel!
    
    // Container to store the view table selected object
    var currentObject : PFObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Hide Tab Bar
        self.tabBarController?.tabBar.hidden = true
        
        //MARK: Nav Bar Customize
        navigationController!.navigationBar.barTintColor = UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
        let detailedQuestionReportBtn:UIBarButtonItem = UIBarButtonItem(title: "Report", style: .Plain, target: self, action: "detailEventReport")
        let detailedQuestionBackBtn:UIBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "detailEventBack")
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.navigationItem.setRightBarButtonItem(detailedQuestionReportBtn, animated: true)
        self.navigationItem.setLeftBarButtonItem(detailedQuestionBackBtn, animated: true)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.title = "Details"
        
        // Unwrap the current object object
        if let object = currentObject {
            eventDetailCreatedBy.text = object["creator"] as! String
            eventDetailEventName.text = object["name"] as! String
            eventDetailEventDate.text = object["dateAndTime"] as! String
            eventDetailEventLocation.text = object["location"] as! String
        }

        // Do any additional setup after loading the view.
    }
    
    //DID RECIEVE MEMORY WARNING
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Report Event Function
    func detailEventReport() {
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
    func detailEventBack(){
        if let navController = self.navigationController {
            self.tabBarController?.tabBar.hidden = false
            navController.popViewControllerAnimated(true)
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
