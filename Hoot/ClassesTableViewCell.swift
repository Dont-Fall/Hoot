//
//  ClassesTableViewCell.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/3/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ClassesTableViewCell: PFTableViewCell {

    @IBOutlet var classNameLabel: UILabel!
    @IBOutlet var classCourseLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
