//
//  MyClassQuestionsTableViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/13/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class MyClassQuestionsTableViewController: PFQueryTableViewController {
    
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
        self.parseClassName = "Question"
        self.textKey = "user"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 100
    }
    
    //MARK: Segment Controller
    @IBOutlet var questionSegmentController: UISegmentedControl!
    
    @IBAction func segmentControllerActn(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.loadObjects()
            self.tableView.reloadData()
            print("first segement clicked")
        case 1:
            self.loadObjects()
            self.tableView.reloadData()
            print("second segment clicked")
        default:
            break;
        }
    }
    
    
    //MAY NOT BE NEEDED Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        var currentUser = PFUser.currentUser()!.username
        var questionsQuery = PFQuery(className: "ClassQuestion")
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
        //MARK: Nav Bar Customize
        navigationController!.navigationBar.barTintColor = UIColor(red: 102.0 / 255.0, green: 204.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
        let myClassQuestionBackBtn:UIBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "myClassQuestionBack")
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.navigationItem.setLeftBarButtonItem(myClassQuestionBackBtn, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.title = "My Class Questions"
        tableView.rowHeight = 100
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
    func myClassQuestionBack() {
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
        
        var cell = tableView.dequeueReusableCellWithIdentifier("myClassQuestionCell") as! MyClassQuestionsTableViewCell!
        if cell == nil {
            cell = MyClassQuestionsTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "myQuestionCell")
        }
        // Extract values from the PFObject to display in the table cell
        if let question = object?["question"] as? String {
            cell?.myClassQuestionTV.text = question
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
        if segue.identifier == "myClassQuestionDetailSegue" {
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
        self.performSegueWithIdentifier("myClassQuestionDetailSegue", sender: self)
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