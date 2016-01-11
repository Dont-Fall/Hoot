//
//  QuestionAnswerViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/11/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class QuestionAnswerViewController: UIViewController {

    @IBOutlet var questionAnswerAnswerTV: UITextView!
    @IBOutlet var questionAnswerPicPreview: UIImageView!
    @IBOutlet var questionAnswerAnswerCount: UILabel!

    @IBAction func questionAnswerAddPicBtn(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
