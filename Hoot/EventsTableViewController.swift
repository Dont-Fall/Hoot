//
//  EventsTableViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/3/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class EventsTableViewController: PFQueryTableViewController {
    
    //MARK: Extras
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150))
    
    @IBOutlet var noDataView: UIView!
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Configure the PFQueryTableView
        self.parseClassName = "Event"
        self.textKey = "name"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 100
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        var currentUser = PFUser.currentUser()
        let currentSchool = currentUser!["school"]
        var questionsQuery = PFQuery(className: "Event")
        questionsQuery.whereKey("school", equalTo: (currentSchool)!)
        questionsQuery.orderByDescending("createdAt")
        return questionsQuery
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.loadObjects()
        self.tableView.reloadData()
    }
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        //MARK: Customize Nav Bar
        let eventsCreateEventBtn:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "createEventSegue")
        navigationController!.navigationBar.barTintColor = UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.navigationItem.setRightBarButtonItem(eventsCreateEventBtn, animated: true)
        self.title = "Events"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    //Move to Create Function
    func createEventSegue() {
        self.actInd.startAnimating()
        self.performSegueWithIdentifier("createEventSegue", sender: self)
        self.actInd.stopAnimating()
    }
    
    //DID RECIEVE MEMORY WARNING
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Prepare To Send Object To Detailed View
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "eventDetailViewIdentifier" {
            // Get the new view controller using [segue destinationViewController].
            var detailScene = segue.destinationViewController as! EventDetailViewController
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
        self.performSegueWithIdentifier("eventDetailViewIdentifier", sender: self)
        self.actInd.stopAnimating()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        noDataView.hidden = true
        var cell = tableView.dequeueReusableCellWithIdentifier("eventsCell") as! EventsTableViewCell!
        if cell == nil {
            cell = EventsTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "eventsCell")
        }
        
        // Extract values from the PFObject to display in the table cell
        if let nameEnglish = object?["name"] as? String {
            cell?.eventNameLabel?.text = nameEnglish
        }
        if let capital = object?["location"] as? String {
            cell?.eventLocationLabel?.text = capital
        }
        if let dateAndTime = object?["dateAndTime"] as? String {
            cell?.eventDateLabel?.text = dateAndTime
        }
        if let attending = object?["attending"] as? Array<String> {
            cell?.eventAttendingCount.text = "\(String(attending.count)) Attending"
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
            cell?.eventTimeStamp.text = String(years) + "y"
        }else if months >= 1{
            cell?.eventTimeStamp.text = String(months) + "m"
        }else if weeks >= 1{
            cell?.eventTimeStamp.text = String(weeks) + "w"
        }else if days >= 1 {
            cell?.eventTimeStamp.text = String(days) + "d"
        }else if Int(hours) >= 1 {
            cell?.eventTimeStamp.text = String(hours) + "h"
        }else if Int(minutes) >= 1 {
            cell?.eventTimeStamp.text = String(minutes) + "m"
        }else{
            cell?.eventTimeStamp.text = String(seconds) + "s"
        }
        //Time Until Event
        //let secondsToGo = NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: (object?["dateAndTime"])! as! NSDate, options: []).second
        //print(secondsToGo)
        return cell
    }

}
