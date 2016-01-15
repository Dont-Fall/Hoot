//
//  AskQuestion.swift
//  Hoot
//
//  Created by Christopher Frost on 1/13/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//  Assistance from Zack Cuomo

import Foundation

class ClassAskQuestion: NSObject {
    
    var userTopic: String?
    var userText: String?
    var image: PFFile?
//    let alert = UIAlertController()
    
    init(topic: String, text: String, img: PFFile){
        self.userTopic = topic
        self.userText = text
        self.image = img
    }
    
    func hasNoEmptyFields() -> Bool{
        if !userTopic!.isEmpty && !userText!.isEmpty{
            return true
        }else{
            return false
        }
    }
    
    func topicSufficientLength() -> Bool{
        if userTopic!.characters.count < 4{
            return false
        }else{
            return true
        }
    }
    
    func questionSufficientLenght() -> Bool{
        if userText!.characters.count > 200{
            return false
        }else{
            return true
        }
    }

    
    func classAskQuestionAlert() throws {
        guard hasNoEmptyFields() else{
            throw Error.EmptyField
        }
        guard topicSufficientLength() else{
            throw Error.InsufficientTopicLength
        }
        guard questionSufficientLenght() else{
            throw Error.InsufficientQuestionLength
        }
    }
}