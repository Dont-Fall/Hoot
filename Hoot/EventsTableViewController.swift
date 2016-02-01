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
    
    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //MARK: Customize Nav Bar
        let eventsCreateEventBtn:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "createEventSegue")
        navigationController!.navigationBar.barTintColor = UIColor(red: 175.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.navigationItem.setRightBarButtonItem(eventsCreateEventBtn, animated: true)
        self.title = "Events"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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

    // MARK: - Table view data source

    /* override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        
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
        if let date = object?["dateAndTime"] as? String {
            cell.eventDateLabel?.text = date
        }
        return cell
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
