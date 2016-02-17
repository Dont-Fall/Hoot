//
//  ClassesTableViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/3/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class ClassesTableViewController: PFQueryTableViewController {
    
    @IBOutlet var noDataView: UIView!
    var deleteClassIndexPath: NSIndexPath? = nil
    
    // Initialise the PFQueryTable tableview
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        // Configure the PFQueryTableView
        self.parseClassName = "Classes"
        self.textKey = "member"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 10
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        let currentUser = PFUser.currentUser()!.username!
        let classesQuery = PFQuery(className: "Classes")
        let list = [currentUser]
        classesQuery.whereKey("members", containedIn: list)
        //classesQuery.whereKey("members", containsString: currentUser)
        //classesQuery.whereKey("member", equalTo: (currentUser))
        classesQuery.orderByDescending("createdAt")
        return classesQuery
    }
    
    //MARK: Extras
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150))

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.loadObjects()
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        //MARK: Customize Nav Bar
        let classesAddClassBtn:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addClassSegue")
        navigationController!.navigationBar.barTintColor = UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.navigationItem.setRightBarButtonItem(classesAddClassBtn, animated: true)
        self.title = "Classes"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        tableView.rowHeight = 100
    }
    
    func addClassSegue() {
        self.performSegueWithIdentifier("addClassSegue", sender: self)
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
        var cell = tableView.dequeueReusableCellWithIdentifier("classCell") as! ClassesTableViewCell!
        if cell == nil {
            cell = ClassesTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "classCell")
        }
        if (indexPath.row) == self.objects!.count{
            return cell
        }
        // Extract values from the PFObject to display in the table cell
        if let nameEnglish = object?["name"] as? String {
            cell?.classNameLabel?.text = nameEnglish
        }
        if let capital = object?["course"] as? String {
            cell?.classCourseLabel?.text = capital
            cell?.detailTextLabel?.numberOfLines = 1
        }
        if let list = object?["members"] as? Array<String>{
            cell?.classMembersCount?.text = String(list.count)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteClassIndexPath = indexPath
            let classToDelete = objects?[indexPath.row]
            confirmDelete(classToDelete!)
            self.loadObjects()
            self.tableView.reloadData()
        }
    }
    
    //Prepare To Send Object To Detailed View
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "classViewSegue" {
            // Get the new view controller using [segue destinationViewController].
            let detailScene = segue.destinationViewController as! ClassQuestionsTableViewController
            // Pass the selected object to the destination view controller.
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let row = Int(indexPath.row)
                detailScene.currentObject = (objects![row])
                detailScene.className = String(objects![row]["name"])
            }
        }
    }
    
    //When Select Row Move to Detail View
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row) == self.objects!.count{
            self.loadNextPage()
        }else{
            let row = indexPath.row
            let currentUser = PFUser.currentUser()
            currentUser!["currentGroupCode"] = objects?[row]["code"]
            currentUser!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if error == nil {
                self.performSegueWithIdentifier("classViewSegue", sender: self)
                } else {
                    //"Error"
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func confirmDelete(Class : PFObject) {
        
        let alert = UIAlertController(title: "Leave Class", message: "Are you sure you want to leave '\(Class["name"])'?", preferredStyle: .ActionSheet)
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeleteClass)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeleteClass)
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func handleDeleteClass(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteClassIndexPath {
            tableView.beginUpdates()
            objects?[indexPath.row].deleteInBackground()
            deleteClassIndexPath = nil
            self.loadObjects()
            self.tableView.reloadData()
            tableView.endUpdates()
        }
    }
    
    func cancelDeleteClass(alertAction: UIAlertAction!) {
        deleteClassIndexPath = nil
    }

}
