//
//  Enums.swift
//  Hoot
//
//  Created by Christopher Frost on 1/11/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import Foundation

enum Error: ErrorType {
    case EmptyField
    case PasswordsDoNotMatch
    case InvalidEmail
    case UserNameTaken
    case IncorrectSignIn
    case InvalidPassword
    case CourseTooShort
    case QuestionTooLong
    //Question Cases
    case InsufficientCourseLength
    case InsufficientTopicLength
    case InsufficientQuestionLength
    case InsufficientEventLength
    case InsufficientLocationLength
    //Contact Us Cases
    case InsufficientContactLength
    case InsufficientTopicLength
    
}

extension Error: CustomStringConvertible {
   
    var description: String {
        switch self {
        case .EmptyField: return "Please fill in all empty fields."
        case .PasswordsDoNotMatch: return "Passwords do not match."
        case .InvalidEmail: return "Please enter a valid email address."
        case .UserNameTaken: return "This username is taken.\nPlease choose another username."
        case .IncorrectSignIn: return "The username or password entered is incorrect."
        case .InvalidPassword: return "Passwords must be 8 or more characters,\n and include a numeric and capital letter."
        //Question Errors
        case .InsufficientCourseLength: return "Please enter a valid course."
        case .InsufficientTopicLength: return "Please enter a valid topic."
        case .InsufficientQuestionLength: return "Question length is too long."
        case .InsufficientEventLength: return "Please enter a valid event name."
        case .InsufficientLocationLength: return "Please enter a valid location."
        //Contact Us Errors
        case .InsufficientContactLength: return "Please enter a more detailed reason for contacting."
        case .InsufficientTopicLength: return "Please enter a topic of sufficient length."
            
        default: return "Sorry, something else went wrong."
        }
    }
}