//
//  AskQuestion.swift
//  Hoot
//
//  Created by Christopher Frost on 1/13/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import Foundation

class AskQuestion: NSObject {
    var userCourse: String?
    var userText: String?
    var image: PFFile?
    let alert = UIAlertController()
    
    init(course: String, text: String, img: PFFile){
        self.userCourse = course
        self.userText = text
        self.image = img
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

    
    func askQuestionAlert() throws -> UIAlertController {
        let alertview = UIAlertController(title: "Uh-oh!", message: "", preferredStyle: .Alert)
        alertview.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        guard hasNoEmptyFields() else{
            
            return alertview
        }
        guard courseSufficientLength() else{
            
            return alertview
        }
        guard questionSufficientLenght() else{

            return alertview
        }
        alertview.title = "Success!"
        alertview.message = "Question now posted!"
        return alertview
    }

    
}