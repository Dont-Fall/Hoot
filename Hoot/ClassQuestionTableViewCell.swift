//
//  ClassQuestionTableViewCell.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/7/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class ClassQuestionTableViewCell: PFTableViewCell {
    
    @IBOutlet var classQuestionTopicLabel: UILabel!
    @IBOutlet var classQuestionQuestionTV: UITextView!
    @IBOutlet var classQuestionPicIndicator: UIImageView!
    @IBOutlet var classQuestionAnswerCount: UILabel!
    @IBOutlet var classQuestionTimestamp: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
