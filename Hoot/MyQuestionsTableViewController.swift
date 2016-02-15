//
//  MyQuestionsTableViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/13/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class MyQuestionsTableViewController: PFQueryTableViewController {
    
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
        self.textKey = "user"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 100
    }
    
    /*MARK: Segment Controller
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
    }*/
    
    
    //MAY NOT BE NEEDED Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        let currentUser = PFUser.currentUser()!.username
        let questionsQuery = PFQuery(className: "Question")
        questionsQuery.whereKey("user", equalTo: currentUser!)
        questionsQuery.orderByDescending("createdAt")
        return questionsQuery
    }
    
    //VIEW DID APPEAR
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if PFUser.currentUser() != nil{
            //None
        }else{
            self.performSegueWithIdentifier("goSignInFromQuestions", sender: self)
        }
        self.tableView.reloadData()
    }
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        //MARK: Nav Bar Customize
        navigationController!.navigationBar.barTintColor = UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
        let myQuestionBackBtn:UIBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "myQuestionBack")
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.navigationItem.setLeftBarButtonItem(myQuestionBackBtn, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.title = "My Questions"
        tableView.rowHeight = 150
    }
    
    //DID RECIEVE MEMORY WARNING
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func removeFromParentViewController() {
        super.removeFromParentViewController()
        if(self.tableView != nil) {
            self.tableView.delegate = nil
            self.tableView.dataSource = nil
            self.tableView = nil
        }
    }
    
    //Funtion for Compose
    func myQuestionBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    //NOT NEEDED FOR QUERY
    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 10
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return 10
    }
    */
    
    //PFQuery For Table
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        noDataView.hidden = true
        var cell = tableView.dequeueReusableCellWithIdentifier("myQuestionCell") as! MyQuestionsTableViewCell!
        if cell == nil {
            cell = MyQuestionsTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "myQuestionCell")
        }
        // Extract values from the PFObject to display in the table cell
        if let question = object?["question"] as? String {
            cell?.myQuestionQuestionTV.text = question
        }
        if let subject = object?["subject"] as? String {
            cell?.myQuestionSubjectLabel.text = subject
        }
        if object?["solved"] as! Bool == true {
            cell?.myQuestionAnsweredPic.image = UIImage(named: "CheckMarkHoot")
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
            cell?.myQuestionTimeStamp.text = String(years) + "y"
        }else if months >= 1{
            cell?.myQuestionTimeStamp.text = String(months) + "m"
        }else if weeks >= 1{
            cell?.myQuestionTimeStamp.text = String(weeks) + "w"
        }else if days >= 1 {
            cell?.myQuestionTimeStamp.text = String(days) + "d"
        }else if Int(hours) >= 1 {
            cell?.myQuestionTimeStamp.text = String(hours) + "h"
        }else if Int(minutes) >= 1 {
            cell?.myQuestionTimeStamp.text = String(minutes) + "m"
        }else{
            cell?.myQuestionTimeStamp.text = String(seconds) + "s"
        }
        //Answer Count
        cell?.myQuestionAnswerCount.text = String(object!["answerCount"]) + " Answers"
        return cell
    }
    
    //Prepare To Send Object To Detailed View
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "myQuestionDetailSegue" {
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
        self.actInd.startAnimating()
        self.performSegueWithIdentifier("myQuestionDetailSegue", sender: self)
        self.actInd.stopAnimating()
    }
    
}