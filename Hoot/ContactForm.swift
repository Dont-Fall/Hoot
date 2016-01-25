//
//  ContactUs.swift
//  Hoot
//
//  Created by Christopher Frost on 1/24/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import Foundation

class ContactForm: NSObject {
    var formTopic: String?
    var formText: String?
    
    init(topic: String, text: String) {
        self.formTopic = topic
        self.formText = text
    }
    
    func hasNoEmptyFields() -> Bool{
        if !formTopic!.isEmpty && !formText!.isEmpty{
            return true
        }else{
            return false
        }
    }
    
    func topicSufficientLength() -> Bool{
        if formTopic!.characters.count < 3{
            return false
        }else{
            return true
        }
    }
    
    func textSufficientLenght() -> Bool{
        if formText!.characters.count < 10{
            return false
        }else{
            return true
        }
    }

    func contactFormAlert() throws {
        guard hasNoEmptyFields() else{
            throw Error.EmptyField
        }
        guard topicSufficientLength() else{
            throw Error.InsufficientTopicLength
        }
        guard textSufficientLenght() else{
            throw Error.InsufficientContactLength
        }
    }

    
    
}