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
    @IBOutlet var questionDetailAnswerPicPreview: UIImageView!
    @IBOutlet var questionDetailAnswerAnswerTV: UITextView!
    @IBOutlet var questionDetailAnswerUsernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
