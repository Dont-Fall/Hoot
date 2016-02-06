//
//  AskQuestion.swift
//  Hoot
//
//  Created by Zack Cuomo on 1/15/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.

import Foundation

class ClassQuestionAnswer: NSObject {
    
    var userAnswer: String?
    //    let alert = UIAlertController()
    
    init(text: String){
        self.userAnswer = text
        
    }
    
    func hasNoEmptyFields() -> Bool{
        if !userAnswer!.isEmpty{
            return true
        }else{
            return false
        }
    }
    
    func classAnswerSufficientLenght() -> Bool{
        if userAnswer!.characters.count > 200{
            return false
        }else{
            return true
        }
    }
    
    func classQuestionAnswerAlert() throws {
        guard hasNoEmptyFields() else{
            throw Error.EmptyField
        }

        guard classAnswerSufficientLenght() else{
            throw Error.InsufficientQuestionLength
        }
    }
}