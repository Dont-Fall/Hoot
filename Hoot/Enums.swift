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
//        case .CourseTooShort: return "test"
//        case .QuestionTooLong: return "test"
        default: return "Sorry, something else went wrong."
        }
    }
    
    var alert: UIAlertController {
        switch self {
        case .EmptyField:
            self.alert.message = "Please fill in all empty fields."
            break
        case .CourseTooShort:
            self.alert.message = "Please enter a valid course."
            break
        case .QuestionTooLong:
            self.alert.message = "Question too long!\nPlease reduce to fewer than 200 characters."
            break
        default:
            self.alert.message = "Error"
            break
        }
        return self.alert
    }
}