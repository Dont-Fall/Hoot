//
//  QuestionDetailAnswerTableViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/11/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class QuestionDetailAnswerTableViewController: PFQueryTableViewController {
    
    // Container to store the view table selected object
    var queryID : String?
    @IBOutlet var noDataView: UIView!

    //MARK: Extras
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150))
    
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    //QUERY DATA
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Configure the PFQueryTableView
        self.parseClassName = "Answer"
        self.textKey = "idNumber"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 100
    }
    
    //MAY NOT BE NEEDED Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
            var answersQuery = PFQuery(className: "Answer")
            answersQuery.whereKey("idNumber", equalTo: queryID!)
            answersQuery.orderByDescending("createdAt")
            return answersQuery
    }
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        //MARK: Nav Bar Customize
        navigationController!.navigationBar.barTintColor = UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
        let questionAnswerBackBtn:UIBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "questionAnswerBack")
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.navigationItem.setLeftBarButtonItem(questionAnswerBackBtn, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        tableView.rowHeight = 150
    }
    
    //DID RECIEVE MEMORY WARNING
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Function for Subject
    func questionAnswerBack() {
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
        var cell = tableView.dequeueReusableCellWithIdentifier("answerCell") as! QuestionDetailAnswerTableViewCell!
        if cell == nil {
            cell = QuestionDetailAnswerTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "answerCell")
        }
        // Extract values from the PFObject to display in the table cell
        if let user = object?["user"] as? String {
            cell?.questionAnswerUserLabel.text = user
        }
        if let answer = object?["answer"] as? String {
            cell?.questionAnswerAnswerTV.text = answer
        }
        if object?["correct"] as! Bool == true {
            cell?.questionAnswerPicIndicator.image = UIImage(named: "CheckMarkHoot")
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
            cell?.questionAnswerTimestamp.text = String(years) + "y"
        }else if months >= 1{
            cell?.questionAnswerTimestamp.text = String(months) + "m"
        }else if weeks >= 1{
            cell?.questionAnswerTimestamp.text = String(weeks) + "w"
        }else if days >= 1 {
            cell?.questionAnswerTimestamp.text = String(days) + "d"
        }else if Int(hours) >= 1 {
            cell?.questionAnswerTimestamp.text = String(hours) + "h"
        }else if Int(minutes) >= 1 {
            cell?.questionAnswerTimestamp.text = String(minutes) + "m"
        }else{
            cell?.questionAnswerTimestamp.text = String(seconds) + "s"
        }
        if object!["picture"] != nil{
            cell?.questionAnswerPicIndicator.hidden = false
            cell?.questionAnswerPicIndicator.image = UIImage(named: "CameraIconHoot")
        }else{
            cell?.questionAnswerPicIndicator.hidden = true
        }
        if object!["correct"].boolValue == true{
            cell?.questionAnswerCorrectIndicator.image = UIImage(named: "CheckMarkHoot")
        }
        return cell
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    // Get the new view controller using [segue destinationViewController].
    var detailScene = segue.destinationViewController as! QuestionDetailedViewController
    
    // Pass the selected object to the destination view controller.
    if let indexPath = self.tableView.indexPathForSelectedRow {
    let row = Int(indexPath.row)
    detailScene.currentObject = objects![row] as? PFObject
    }
    }
    */
    
    //Prepare To Send Object To Detailed View
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "questionAnswerSelectedSegue" {
            // Get the new view controller using [segue destinationViewController].
            var detailScene = segue.destinationViewController as! QuestionDetailAnswerSelectedViewController
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
        self.performSegueWithIdentifier("questionAnswerSelectedSegue", sender: self)
        self.actInd.stopAnimating()
    }
    
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
