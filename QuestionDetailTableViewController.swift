//
//  QuestionDetailTableViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/11/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class QuestionDetailTableViewController: PFQueryTableViewController {
    
    
    // Container to store the view table selected object
    @IBOutlet var questionDetailTableView: UITableView!
    
    var questionDetailUsername = ""
    var questionDetailQuestion = ""
    var questionDetailPicture: UIImage!
    
    var currentObject : PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionDetailTableView.delegate = self
        questionDetailTableView.dataSource = self
        
        // Unwrap the current object object
        if let object = currentObject {
            
            let userImageFile = object["picture"] as! PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        self.questionDetailPicture = image
                    }
                }
            }
            
            self.questionDetailUsername = object["user"] as! String
            self.questionDetailQuestion = object["question"] as! String
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    //Question Part
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> QuestionDetailQuestionTableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("questionDetailCell") as! QuestionDetailQuestionTableViewCell!
        if cell == nil {
            cell = QuestionDetailQuestionTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "questionDetailCell")
        }
        
        // Extract values from the PFObject to display in the table cell
        if let username = questionDetailUsername as? String {
            cell?.questionDetailQuestionUsernameLabel.text = username
        }
        if let question = questionDetailQuestion as? String {
            cell?.questionDetailQuestionQuestionTV.text = question
        }
        return cell
    }
    
    //PFQuery For Table
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> QuestionDetailAnswerTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("questionAnswerCell") as! QuestionDetailAnswerTableViewCell!
        if cell == nil {
            cell = QuestionDetailAnswerTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "questionAnswerCell")
        }
        // Extract values from the PFObject to display in the table cell
        if let nameEnglish = object?["question"] as? String {
            cell?.questionDetailAnswerAnswerTV.text = nameEnglish
        }
        if let capital = object?["course"] as? String {
            cell?.questionDetailAnswerUsernameLabel?.text = capital
        }
        return cell
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
