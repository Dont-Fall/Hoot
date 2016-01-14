//
//  MyClassQuestionsTableViewCell.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/14/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class MyClassQuestionsTableViewCell: PFTableViewCell {

    @IBOutlet var myClassQuestionTV: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
