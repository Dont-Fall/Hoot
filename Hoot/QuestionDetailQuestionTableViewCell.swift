//
//  QuestionDetailQuestionTableViewCell.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/11/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class QuestionDetailQuestionTableViewCell: UITableViewCell {
    
    //MARK: Connections
    
    @IBOutlet var questionDetailQuestionUsernameLabel: UILabel!
    @IBOutlet var questionDetailQuestionQuestionTV: UITextView!
    @IBOutlet var questionDetailQuestionPicPreview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
