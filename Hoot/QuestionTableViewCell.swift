//
//  QuestionTableViewCell.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/2/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class QuestionTableViewCell: PFTableViewCell {

    @IBOutlet var questionQuestionText: UILabel!
    @IBOutlet var questionQuestionLabel: UILabel!
    @IBOutlet var questionCourseLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
