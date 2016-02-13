//
//  ClassQuestionAnswerCell.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/13/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class ClassQuestionAnswerCell: PFTableViewCell {
    
    //MARK: Connections
    @IBOutlet var classQuestionAnswerUserLabel: UILabel!
    @IBOutlet var classQuestionAnswerAnswerTV: UITextView!
    @IBOutlet var classQuestionAnswerTimestamp: UILabel!
    @IBOutlet var classQuestionAnswerCorrectIndicator: UIImageView!
    @IBOutlet var classQuestionAnswerPicIndicator: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
