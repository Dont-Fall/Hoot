//
//  TermsOfServiceViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 2/14/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class TermsOfServiceViewController: UIViewController {
    
    var state: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tosBackBtn(sender: AnyObject) {
        self.performSegueWithIdentifier("tosBackSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailScene = segue.destinationViewController as! TermsViewController
        // Pass the selected object to the destination view controller.
        detailScene.state = state
    }
}
