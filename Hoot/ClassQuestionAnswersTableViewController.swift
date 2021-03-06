//
//  ClassQuestionAnswersTableViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/13/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class ClassQuestionAnswersTableViewController: PFQueryTableViewController {
    
    @IBOutlet var noDataView: UIView!
    // Container to store the view table selected object
    var queryID : String?
    var questionObject: PFObject!
    
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
        self.parseClassName = "ClassAnswer"
        self.textKey = "idNumber"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 25
    }
    
    //MAY NOT BE NEEDED Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        let answersQuery = PFQuery(className: "ClassAnswer")
        answersQuery.whereKey("idNumber", equalTo: queryID!)
        answersQuery.orderByDescending("createdAt")
        return answersQuery
    }
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        self.loadObjects()
        self.tableView.reloadData()
        //MARK: Nav Bar Customize
        navigationController!.navigationBar.barTintColor = UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
        let questionAnswerBackBtn:UIBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "questionAnswerBack")
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.navigationItem.setLeftBarButtonItem(questionAnswerBackBtn, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
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
    
    override func tableView(tableView: UITableView, cellForNextPageAtIndexPath indexPath: NSIndexPath) -> PFTableViewCell? {
        var cell = tableView.dequeueReusableCellWithIdentifier("loadMoreCell") as! LoadMoreTableViewCell!
        if cell == nil{
            cell = LoadMoreTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "loadMoreCell")
        }
        cell.loadMoreLabel.text = "Load More"
        return cell
    }
    
    //PFQuery For Table
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        noDataView.hidden = true
        var cell = tableView.dequeueReusableCellWithIdentifier("classAnswerCell") as! ClassQuestionAnswerCell!
        if cell == nil {
            cell = ClassQuestionAnswerCell(style: UITableViewCellStyle.Default, reuseIdentifier: "classAnswerCell")
        }
        if (indexPath.row) == self.objects!.count{
            return cell
        }
        // Extract values from the PFObject to display in the table cell
        if let user = object?["user"] as? String {
            cell?.classQuestionAnswerUserLabel.text = user
        }
        if let answer = object?["answer"] as? String {
            cell?.classQuestionAnswerAnswerTV.text = answer
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
            cell?.classQuestionAnswerTimestamp.text = String(years) + "y"
        }else if months >= 1{
            cell?.classQuestionAnswerTimestamp.text = String(months) + "m"
        }else if weeks >= 1{
            cell?.classQuestionAnswerTimestamp.text = String(weeks) + "w"
        }else if days >= 1 {
            cell?.classQuestionAnswerTimestamp.text = String(days) + "d"
        }else if Int(hours) >= 1 {
            cell?.classQuestionAnswerTimestamp.text = String(hours) + "h"
        }else if Int(minutes) >= 1 {
            cell?.classQuestionAnswerTimestamp.text = String(minutes) + "m"
        }else{
            cell?.classQuestionAnswerTimestamp.text = String(seconds) + "s"
        }
        if object!["picture"] != nil{
            cell?.classQuestionAnswerPicIndicator.hidden = false
            cell?.classQuestionAnswerPicIndicator.image = UIImage(named: "CameraIconHoot")
        }else{
            cell?.classQuestionAnswerPicIndicator.hidden = true
        }
        if object?["correct"] as! Bool == true {
            cell?.classQuestionAnswerCorrectIndicator.image = UIImage(named: "CheckMarkHoot")
        }
        return cell
    }
    
    //Prepare To Send Object To Detailed View
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "classQuestionAnswerSelectedSegue" {
            // Get the new view controller using [segue destinationViewController].
            let detailScene = segue.destinationViewController as! ClassQuestionAnswerSelectedViewController
            // Pass the selected object to the destination view controller.
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let row = Int(indexPath.row)
                detailScene.currentObject = (objects![row])
                detailScene.questionObject = questionObject
            }
        }
    }
    
    //When Select Row Move to Detail View
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row) == self.objects!.count{
            self.loadNextPage()
        }else {
            self.performSegueWithIdentifier("classQuestionAnswerSelectedSegue", sender: self)
        }
    }
    
}