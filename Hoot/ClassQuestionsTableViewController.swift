//
//  ClassQuestionsTableViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/7/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class ClassQuestionsTableViewController: PFQueryTableViewController {
    @IBOutlet var noDataView: UIView!
    
    var nothingToLoad = false
    
    // Container to store the view table selected object
    var currentObject : PFObject?
    
    //MARK: Extras
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150))
    
    //Segment Controller
    let scItems = ["Asked", "Solved"]
    var customSC = UISegmentedControl()
    var className: String?

    
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Configure the PFQueryTableView
        self.parseClassName = "ClassQuestion"
        self.textKey = "code"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 25
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        let index: Int = customSC.selectedSegmentIndex
        let currentUser = PFUser.currentUser()
        let currentUserCode = currentUser!["currentGroupCode"]
        let currentUserSchool = currentUser!["school"]
        let questionsQuery = PFQuery(className: "ClassQuestion")
        if index == 0 {
            questionsQuery.whereKey("school", equalTo: (currentUserSchool)!)
            questionsQuery.whereKey("code", equalTo: (currentUserCode)!)
            questionsQuery.whereKey("solved", equalTo: false)
            questionsQuery.orderByDescending("createdAt")
            return questionsQuery
        }else{
            questionsQuery.whereKey("school", equalTo: (currentUserSchool)!)
            questionsQuery.whereKey("code", equalTo: (currentUserCode)!)
            questionsQuery.whereKey("solved", equalTo: true)
            questionsQuery.orderByDescending("createdAt")
            return questionsQuery
        }
    }
    
    //VIEW DID APPEAR
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let user = PFUser.currentUser()
        user?.fetchInBackgroundWithBlock(nil)
        let tokens = String(PFUser.currentUser()!.objectForKey("tokens")!)
        let myTokens:UIBarButtonItem = UIBarButtonItem(title: tokens, style: .Plain, target: self, action: nil)
        let questionAskBtn:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "classQuestionCompose")
        self.navigationItem.setRightBarButtonItems([questionAskBtn, myTokens], animated: true)
        self.loadObjects()
        self.tableView.reloadData()
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        //Segment Controller
        customSC = UISegmentedControl(items: scItems)
        customSC.selectedSegmentIndex = 0
        loadObjects()
        tableView.reloadData()
        customSC.addTarget(self, action: "segmentedControlValueChanged:", forControlEvents:.ValueChanged)
        customSC.addTarget(self, action: "segmentedControlValueChanged:", forControlEvents:.TouchUpInside)
        //MARK: Nav Bar Customize
        let tokens = String(PFUser.currentUser()!.objectForKey("tokens")!)
        let myTokens:UIBarButtonItem = UIBarButtonItem(title: tokens, style: .Plain, target: self, action: nil)
        navigationController!.navigationBar.barTintColor = UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
        let questionBackBtn:UIBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "classQuestionBack")
        let questionAskBtn:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "classQuestionCompose")
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.navigationItem.titleView = customSC
        self.navigationItem.setRightBarButtonItems([questionAskBtn, myTokens], animated: true)
        self.navigationItem.setLeftBarButtonItem(questionBackBtn, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        tableView.estimatedRowHeight = 200
    }
    
    //Funtion for Compose
    func classQuestionCompose() {
        if Int((PFUser.currentUser()?.objectForKey("tokens"))! as! NSNumber) > 0 {
            self.performSegueWithIdentifier("classComposeSegue", sender: self)
        }else{
            let alert = UIAlertController(title: "No Tokens", message: "You are out of tokens, go get some from the 'more' tab.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //Segment Controller Function
    func segmentedControlValueChanged(segment: UISegmentedControl){
        if customSC.selectedSegmentIndex == 1{
            self.loadObjects()
            self.tableView.reloadData()
            print("first segement clicked")
        }else if customSC.selectedSegmentIndex == 0{
            self.loadObjects()
            self.tableView.reloadData()
            print("second segment clicked")
        }
    }
    
    //Go Back
    func classQuestionBack() {
        navigationController?.popViewControllerAnimated(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForNextPageAtIndexPath indexPath: NSIndexPath) -> PFTableViewCell? {
        var cell = tableView.dequeueReusableCellWithIdentifier("loadMoreCell") as! LoadMoreTableViewCell!
        if cell == nil{
            cell = LoadMoreTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "loadMoreCell")
        }
        cell.loadMoreLabel.text = "Load More"
        return cell
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        noDataView.hidden = true
        var cell = tableView.dequeueReusableCellWithIdentifier("classQuestionCell") as! ClassQuestionTableViewCell!
        if cell == nil {
            cell = ClassQuestionTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "classQuestionCell")
        }
        if (indexPath.row) == self.objects!.count{
            return cell
        }
        // Extract values from the PFObject to display in the table cell
        if let nameEnglish = object?["question"] as? String {
            cell?.classQuestionQuestionTV?.text = nameEnglish
        }
        if let capital = object?["topic"] as? String {
            cell?.classQuestionTopicLabel?.text = capital
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
            cell?.classQuestionTimestamp.text = String(years) + "y"
        }else if months >= 1{
            cell?.classQuestionTimestamp.text = String(months) + "m"
        }else if weeks >= 1{
            cell?.classQuestionTimestamp.text = String(weeks) + "w"
        }else if days >= 1 {
            cell?.classQuestionTimestamp.text = String(days) + "d"
        }else if Int(hours) >= 1 {
            cell?.classQuestionTimestamp.text = String(hours) + "h"
        }else if Int(minutes) >= 1 {
            cell?.classQuestionTimestamp.text = String(minutes) + "m"
        }else{
            cell?.classQuestionTimestamp.text = String(seconds) + "s"
        }
        //Answer Count
        cell?.classQuestionAnswerCount.text = String(object!["answerCount"]) + " Answers"
        //Pic Indicator
        if object!["picture"] != nil{
            cell?.classQuestionPicIndicator.hidden = false
            cell?.classQuestionPicIndicator.image = UIImage(named: "CameraIconHoot")
        }else{
            cell?.classQuestionPicIndicator.hidden = true
        }
        
        return cell
    }
    
    //Prepare To Send Object To Detailed View
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "classQuestionDetailedViewIdentifier" {
            // Get the new view controller using [segue destinationViewController].
            let detailScene = segue.destinationViewController as! ClassQuestionDetailedViewController
            // Pass the selected object to the destination view controller.
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let row = Int(indexPath.row)
                detailScene.currentObject = (objects![row])
            }
        }
        if segue.identifier == "classComposeSegue" {
            let detailScene = segue.destinationViewController as! ClassAskQuestionViewController
            detailScene.className = className
        }
    }
    
    //When Select Row Move to Detail View
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row) == self.objects!.count{
            self.loadNextPage()
        }else {
            self.performSegueWithIdentifier("classQuestionDetailedViewIdentifier", sender: self)
        }
    }

}
