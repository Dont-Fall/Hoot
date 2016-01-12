//
//  QuestionDetailAnswerTableViewCell.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/9/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class QuestionDetailAnswerTableViewCell: PFTableViewCell {

    //MARK: Connections
    @IBOutlet var questionAnswerUserLabel: UILabel!
    @IBOutlet var questionAnswerAnswerTV: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
