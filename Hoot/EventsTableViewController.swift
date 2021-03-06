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
        self.objectsPerPage = 25
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        let currentUser = PFUser.currentUser()
        let currentSchool = currentUser!["school"]
        let questionsQuery = PFQuery(className: "Event")
        questionsQuery.whereKey("school", equalTo: (currentSchool)!)
        questionsQuery.orderByAscending("dateAndTime")
        return questionsQuery
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.loadObjects()
        self.tableView.reloadData()
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
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
        self.performSegueWithIdentifier("createEventSegue", sender: self)
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
            let detailScene = segue.destinationViewController as! EventDetailViewController
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
            self.performSegueWithIdentifier("eventDetailViewIdentifier", sender: self)
        }
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
        var cell = tableView.dequeueReusableCellWithIdentifier("eventsCell") as! EventsTableViewCell!
        if cell == nil {
            cell = EventsTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "eventsCell")
        }
        if (indexPath.row) == self.objects!.count{
            return cell
        }
        // Extract values from the PFObject to display in the table cell
        if let nameEnglish = object?["name"] as? String {
            cell?.eventNameLabel?.text = nameEnglish
        }
        if let capital = object?["location"] as? String {
            cell?.eventLocationLabel?.text = capital
        }
        if let dateAndTime = object?["dateAndTimeString"] as? String {
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
        let push = PFPush()
        let channels = [String(object!["pushCodeOwner"]), String(object!["pushCodeOwner"])]
        push.setChannels(channels)
        push.setMessage("The event you signed up for '\(object!["name"])' is less than an hour away!")
        //Time Until Event
        let secondsToGo = NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: (object?["dateAndTime"])! as! NSDate, options: []).second
        if secondsToGo > 0{
            let yearsToGo = Int(secondsToGo/31540000)
            let monthsToGo = Int(secondsToGo/26280000)
            let weeksToGo = Int(secondsToGo/604800)
            let daysToGo = Int(secondsToGo/86400)
            let hoursToGo = Int(secondsToGo/3600)
            let minutesToGo = Int(secondsToGo/60)
            if yearsToGo >= 1{
                cell?.eventTimeToGo.text = String(yearsToGo) + "y To Go"
            }else if monthsToGo >= 1{
                cell?.eventTimeToGo.text = String(monthsToGo) + "m To Go"
            }else if weeksToGo >= 1{
                cell?.eventTimeToGo.text = String(weeksToGo) + "w To Go"
            }else if daysToGo >= 1 {
                cell?.eventTimeToGo.text = String(daysToGo) + "d To Go"
            }else if hoursToGo >= 1 {
                cell?.eventTimeToGo.text = String(hoursToGo) + "h To Go"
            }else if minutesToGo >= 1 {
                if object!["warningSent"].boolValue == false{
                    push.sendPushInBackground()
                    object!["warningSent"] = true
                    object!.saveInBackground()
                }
                cell?.eventTimeToGo.text = String(minutesToGo) + "m To Go"
            }else{
                cell?.eventTimeToGo.text = String(secondsToGo) + "s To Go"
            }
            
        }else{
            cell?.eventTimeToGo.text = "Happening Now!"
        }
        if secondsToGo < -10800{
            object?.deleteInBackground()
        }
        return cell
    }

}
