//
//  ClassQuestionsTableViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/7/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ClassQuestionsTableViewController: PFQueryTableViewController {
    
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
        if index == 0 {
            var currentUser = PFUser.currentUser()
            let currentUserCode = currentUser!["currentGroupCode"]
            var questionsQuery = PFQuery(className: "ClassQuestion")
            questionsQuery.whereKey("code", equalTo: (currentUserCode)!)
            questionsQuery.whereKey("solved", equalTo: false)
            questionsQuery.orderByDescending("createdAt")
            return questionsQuery
        }else{
            var currentUser = PFUser.currentUser()
            let currentUserCode = currentUser!["currentGroupCode"]
            var questionsQuery = PFQuery(className: "ClassQuestion")
            questionsQuery.whereKey("code", equalTo: (currentUserCode)!)
            questionsQuery.whereKey("solved", equalTo: true)
            questionsQuery.orderByDescending("createdAt")
            return questionsQuery
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //Segment Controller
        customSC = UISegmentedControl(items: scItems)
        customSC.selectedSegmentIndex = 0
        print(nothingToLoad)
        //MARK: Nav Bar Customize
        navigationController!.navigationBar.barTintColor = UIColor(red: 102.0 / 255.0, green: 204.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
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
    
    //Go Back
    func classQuestionBack() {
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    /*Prepare To Send Object To Detailed View
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "classViewIdentifier" {
            // Get the new view controller using [segue destinationViewController].
            var detailScene = segue.destinationViewController as! classViewViewController
            // Pass the selected object to the destination view controller.
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let row = Int(indexPath.row)
                detailScene.currentObject = (objects![row] as? PFObject)
            }
        }
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
        
        var cell = tableView.dequeueReusableCellWithIdentifier("classQuestionCell") as! ClassQuestionTableViewCell!
        if cell == nil {
            cell = ClassQuestionTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "classQuestionCell")
        }
        
        // Extract values from the PFObject to display in the table cell
        if let nameEnglish = object?["question"] as? String {
            cell?.classQuestionQuestionLabel?.text = nameEnglish
        }
        if let capital = object?["code"] as? String {
            cell?.detailTextLabel?.text = capital
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