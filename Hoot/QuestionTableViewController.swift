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
            case 1:
                self.loadObjects()
                self.tableView.reloadData()
            default:
                break;
            }
    }
    
    
    //Define the query that will provide the data for the table view
        override func queryForTable() -> PFQuery {
            let questionsQuery = PFQuery(className: "Question")
            if PFUser.currentUser() != nil {
                let index: Int = questionSegmentController.selectedSegmentIndex
                if index == 0 {
                    let currentUser = PFUser.currentUser()
                    let currentSubject = currentUser!["subject"]
                    let currentSchool = currentUser!["school"]
                    questionsQuery.whereKey("subject", equalTo: (currentSubject)!)
                    questionsQuery.whereKey("school", equalTo: (currentSchool)!)
                    questionsQuery.whereKey("solved", equalTo: false)
                    questionsQuery.orderByDescending("createdAt")
                }else{
                    let currentUser = PFUser.currentUser()
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
            //print("Successfully retrieved \(objects!.count) scores.")
            return questionsQuery
    }
    
    //VIEW DID APPEAR
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let user = PFUser.currentUser()
        user?.fetchInBackgroundWithBlock(nil)
        if user == nil{
            self.performSegueWithIdentifier("goSignInFromQuestions", sender: self)
        }else if user?["emailVerified"] as? Bool  == false {
            self.performSegueWithIdentifier("emailVerifySegue", sender: self)
        }else{
            UINavigationBar.appearance().tintColor = UIColor.whiteColor()
            UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            let tokens = String(PFUser.currentUser()!.objectForKey("tokens")!)
            let myTokens:UIBarButtonItem = UIBarButtonItem(title: tokens, style: .Plain, target: self, action: nil)
            let questionAskBtn:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "questionCompose")
            self.navigationItem.setRightBarButtonItems([questionAskBtn, myTokens], animated: true)
            self.loadObjects()
            self.tableView.reloadData()
        }
    }

    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUser = PFUser.currentUser()
        currentUser?.fetchInBackgroundWithBlock(nil)

        UIApplication.sharedApplication().statusBarStyle = .LightContent
        if PFUser.currentUser() != nil{
            let questionAskBtn:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "questionCompose")
            let tokens = String(PFUser.currentUser()!.objectForKey("tokens")!)
            let myTokens:UIBarButtonItem = UIBarButtonItem(title: tokens, style: .Plain, target: self, action: nil)
            self.navigationItem.setRightBarButtonItems([questionAskBtn, myTokens], animated: true)
        }
        let questionSubjectBtn:UIBarButtonItem = UIBarButtonItem(title: "Subject", style: .Plain, target: self, action: "questionSubject")
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
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
        if Int((PFUser.currentUser()?.objectForKey("tokens"))! as! NSNumber) > 0 {
            self.performSegueWithIdentifier("composeSegue", sender: self)
        }else{
            let alert = UIAlertController(title: "No Tokens", message: "You are out of tokens, go get some from the 'more' tab.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    //Function for Subject
    func questionSubject() {
        self.actInd.startAnimating()
        self.performSegueWithIdentifier("subjectSegue", sender: self)
        self.actInd.stopAnimating()
    }
    
    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 25
    }*/
    
    //PFQuery For Table
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        noDataView.hidden=true
        print(self.objects!.count)
        var cell = tableView.dequeueReusableCellWithIdentifier("questionCell") as! QuestionTableViewCell!
        if cell == nil {
            cell = QuestionTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "questionCell")
        }
        if (indexPath.row) == self.objects!.count{
            //self.loadNextPage()
            cell?.questionCourseLabel.text = "Load More"
            return cell
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
            cell?.questionPicIndicator.hidden = false
            cell?.questionPicIndicator.image = UIImage(named: "CameraIconHoot")
        }else{
            cell?.questionPicIndicator.hidden = true
        }
        return cell
    }
    //Prepare To Send Object To Detailed View
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "questionDetailedViewIdentifier" {
        // Get the new view controller using [segue destinationViewController].
        let detailScene = segue.destinationViewController as! QuestionDetailedViewController
        // Pass the selected object to the destination view controller.
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let row = Int(indexPath.row)
            detailScene.currentObject = (objects![row])
            }
        }
    }
    //When Select Row Move to Detail View
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row) == self.objects!.count{
            self.loadNextPage()
        }else{
            self.performSegueWithIdentifier("questionDetailedViewIdentifier", sender: self)
        }
    }

}
