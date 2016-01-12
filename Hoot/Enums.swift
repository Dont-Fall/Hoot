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
        }
    }
}