//
//  MyQuestionsTableViewCell.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/13/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class MyQuestionsTableViewCell: PFTableViewCell {

    @IBOutlet var myQuestionQuestionTV: UITextView!
    @IBOutlet var myQuestionSubjectLabel: UILabel!
    @IBOutlet var myQuestionAnsweredPic: UIImageView!
    @IBOutlet var myQuestionTimeStamp: UILabel!
    @IBOutlet var myQuestionAnswerCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
