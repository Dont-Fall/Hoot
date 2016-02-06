//
//  AskQuestion.swift
//  Hoot
//
//  Created by Christopher Frost on 1/13/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//  Assistance from Zack Cuomo

import Foundation

class QuestionAnswer: NSObject {
    
    var userCourse: String?
    var userText: String?
    var image: PFFile?
    var answerCount: Int?
//    let alert = UIAlertController()
    
    init(course: String, text: String, img: PFFile){
        self.userCourse = course
        self.userText = text
        self.image = img
        self.answerCount = 0
    }
    
    func hasNoEmptyFields() -> Bool{
        if !userCourse!.isEmpty && !userText!.isEmpty{
            return true
        }else{
            return false
        }
    }
    
    func courseSufficientLength() -> Bool{
        if userCourse!.characters.count < 4{
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

    
    func questionAnswerAlert() throws {
        guard hasNoEmptyFields() else{
            throw Error.EmptyField
        }
        guard courseSufficientLength() else{
            throw Error.InsufficientCourseLength
        }
        guard questionSufficientLenght() else{
            throw Error.InsufficientQuestionLength
        }
    }
}