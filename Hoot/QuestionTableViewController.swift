//
//  QuestionTableViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/2/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class QuestionTableViewController: PFQueryTableViewController {

    //MARK: Extras
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150))
    
    @IBOutlet var noDataView: UIView!

    
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    //QUERY DATA
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        // Configure the PFQueryTableView
        self.parseClassName = "Question"
        self.textKey = "subject"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 25
    }
    
    //MARK: Segment Controller
    @IBOutlet var questionSegmentController: UISegmentedControl!
    
    @IBAction func segmentControllerActn(sender: UISegmentedControl) {
            switch sender.selectedSegmentIndex {
            case 0:
                self.loadObjects()
                self.tableView.reloadData()
                print("first segement clicked")
            case 1:
                self.loadObjects()
                self.tableView.reloadData()
                print("second segment clicked")
            default:
                break;
            }
    }
    
    
    //Define the query that will provide the data for the table view
        override func queryForTable() -> PFQuery {
            var questionsQuery = PFQuery(className: "Question")
            if PFUser.currentUser() != nil {
                var index: Int = questionSegmentController.selectedSegmentIndex
                if index == 0 {
                    var currentUser = PFUser.currentUser()
                    let currentSubject = currentUser!["subject"]
                    let currentSchool = currentUser!["school"]
                    questionsQuery.whereKey("subject", equalTo: (currentSubject)!)
                    questionsQuery.whereKey("school", equalTo: (currentSchool)!)
                    questionsQuery.whereKey("solved", equalTo: false)
                    questionsQuery.orderByDescending("createdAt")
                }else{
                    var currentUser = PFUser.currentUser()
                    let currentSubject = currentUser!["subject"]
                    let currentSchool = currentUser!["school"]
                    questionsQuery.whereKey("subject", equalTo: (currentSubject)!)
                    questionsQuery.whereKey("school", equalTo: (currentSchool)!)
                    questionsQuery.whereKey("solved", equalTo: true)
                    questionsQuery.orderByDescending("updatedAt")
                }
            }else{
                //Shouldnt Occur
            }
            return questionsQuery
    }
    
    //VIEW DID APPEAR
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        var user = PFUser.currentUser()
        if user == nil{
            self.performSegueWithIdentifier("goSignInFromQuestions", sender: self)
        }else if user?["emailVerified"] as? Bool  == false {
            print("false")
            self.performSegueWithIdentifier("emailVerifySegue", sender: self)
        }else{
            print("nothing")
            //Nothing
        }
        self.loadObjects()
        self.tableView.reloadData()
    }

    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        print("VIEW DID LOAD")
        var user = PFUser.currentUser()
        /*user!["emailVerified"] = false
        user!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if error == nil {
                print("Points Updated")
            } else {
                print("Error")
            }
        }*/
        print(user?.username)
        print(user?.objectForKey("emailVerified"))
        
        //MARK: Nav Bar Customize
        navigationController!.navigationBar.barTintColor = UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 2.0)
        let questionSubjectBtn:UIBarButtonItem = UIBarButtonItem(title: "Subject", style: .Plain, target: self, action: "questionSubject")
        let questionAskBtn:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "questionCompose")
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.navigationItem.setRightBarButtonItem(questionAskBtn, animated: true)
        self.navigationItem.setLeftBarButtonItem(questionSubjectBtn, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    //DID RECIEVE MEMORY WARNING
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Funtion for Compose
    func questionCompose() {
        self.actInd.startAnimating()
        self.performSegueWithIdentifier("composeSegue", sender: self)
        self.actInd.stopAnimating()
        
    }
    
    //Function for Subject
    func questionSubject() {
        self.actInd.startAnimating()
        self.performSegueWithIdentifier("subjectSegue", sender: self)
        self.actInd.stopAnimating()
    }
    
    //PFQuery For Table
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        noDataView.hidden=true
        var cell = tableView.dequeueReusableCellWithIdentifier("questionCell") as! QuestionTableViewCell!
        if cell == nil {
            cell = QuestionTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "questionCell")
        }
        // Extract values from the PFObject to display in the table cell
        if let nameEnglish = object?["question"] as? String {
            cell?.questionQuestionTV.text = nameEnglish
        }
        if let capital = object?["course"] as? String {
            cell?.questionCourseLabel?.text = capital
        }
        //Time Stamp
        let date = NSDate()
        let seconds = Int((date.timeIntervalSinceDate((object?.createdAt)!)))
        let years = Int(seconds/31540000)
        let months = Int(seconds/26280000)
        let weeks = Int(seconds/604800)
        let days = Int(seconds/86400)
        let hours = Int(seconds/3600)
        let minutes = Int(seconds/60)
        if years >= 1{
            cell?.questionTimeStamp.text = String(years) + "y"
        }else if months >= 1{
            cell?.questionTimeStamp.text = String(months) + "m"
        }else if weeks >= 1{
            cell?.questionTimeStamp.text = String(weeks) + "w"
        }else if days >= 1 {
            cell?.questionTimeStamp.text = String(days) + "d"
        }else if Int(hours) >= 1 {
            cell?.questionTimeStamp.text = String(hours) + "h"
        }else if Int(minutes) >= 1 {
            cell?.questionTimeStamp.text = String(minutes) + "m"
        }else{
            cell?.questionTimeStamp.text = String(seconds) + "s"
        }
        //Answer Count
        cell?.questionAnswerCount.text = String(object!["answerCount"]) + " Answers"
        //Pic Indicator
        if object!["picture"] != nil{
            cell?.questionPicIndicator.image = UIImage(named: "CameraIconHoot")
        }
        return cell
    }
    //Prepare To Send Object To Detailed View
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "questionDetailedViewIdentifier" {
        // Get the new view controller using [segue destinationViewController].
        var detailScene = segue.destinationViewController as! QuestionDetailedViewController
        // Pass the selected object to the destination view controller.
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let row = Int(indexPath.row)
            detailScene.currentObject = (objects![row] as? PFObject)
            }
        }
    }
    //When Select Row Move to Detail View
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.actInd.startAnimating()
        self.performSegueWithIdentifier("questionDetailedViewIdentifier", sender: self)
        self.actInd.stopAnimating()
    }

}
