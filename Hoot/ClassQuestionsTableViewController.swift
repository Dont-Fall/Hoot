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
        self.objectsPerPage = 100
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        var index: Int = customSC.selectedSegmentIndex
        var currentUser = PFUser.currentUser()
        let currentUserCode = currentUser!["currentGroupCode"]
        var questionsQuery = PFQuery(className: "ClassQuestion")
        if index == 0 {
            questionsQuery.whereKey("code", equalTo: (currentUserCode)!)
            questionsQuery.whereKey("solved", equalTo: false)
            questionsQuery.orderByDescending("createdAt")
            return questionsQuery
        }else{
            questionsQuery.whereKey("code", equalTo: (currentUserCode)!)
            questionsQuery.whereKey("solved", equalTo: true)
            questionsQuery.orderByDescending("createdAt")
            return questionsQuery
        }
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
        navigationController!.navigationBar.barTintColor = UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
        let questionSubjectBtn:UIBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "classQuestionBack")
        let questionAskBtn:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "classQuestionCompose")
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.navigationItem.titleView = customSC
        self.navigationItem.setRightBarButtonItem(questionAskBtn, animated: true)
        self.navigationItem.setLeftBarButtonItem(questionSubjectBtn, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        tableView.estimatedRowHeight = 200
        
        //tableView.rowHeight = UITableViewAutomaticDimension
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    //Funtion for Compose
    func classQuestionCompose() {
        self.actInd.startAnimating()
        self.performSegueWithIdentifier("classComposeSegue", sender: self)
        self.actInd.stopAnimating()
        
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        noDataView.hidden = true
        var cell = tableView.dequeueReusableCellWithIdentifier("classQuestionCell") as! ClassQuestionTableViewCell!
        if cell == nil {
            cell = ClassQuestionTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "classQuestionCell")
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
            cell?.classQuestionPicIndicator.image = UIImage(named: "CameraIconHoot")
        }
        
        return cell
    }
    
    //Prepare To Send Object To Detailed View
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "classQuestionDetailedViewIdentifier" {
            // Get the new view controller using [segue destinationViewController].
            var detailScene = segue.destinationViewController as! ClassQuestionDetailedViewController
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
        self.performSegueWithIdentifier("classQuestionDetailedViewIdentifier", sender: self)
        self.actInd.stopAnimating()
    }
    
    

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
