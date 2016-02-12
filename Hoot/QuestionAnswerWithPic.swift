//
//  AskQuestion.swift
//  Hoot
//
//  Created by Christopher Frost on 1/13/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//  Assistance from Zack Cuomo

import Foundation

class QuestionAnswerWithPic: NSObject {
    
    var userAnswer: String?
    
    init(text: String){
        self.userAnswer = text

    }
    
    func hasNoEmptyFields() -> Bool{
        if userAnswer!.isEmpty{
            return true
        }else{
            return false
        }
    }
    
    func answerSufficientLenght() -> Bool{
        if userAnswer!.characters.count > 200{
            return false
        }else{
            return true
        }
    }

    func questionAnswerAlert() throws {
        guard hasNoEmptyFields() else{
            throw Error.EmptyField
        }
        guard answerSufficientLenght() else{
            throw Error.InsufficientQuestionLength
        }
    }
}