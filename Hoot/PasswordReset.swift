//
//  PasswordReset.swift
//  Hoot
//
//  Created by Christopher Frost on 2/6/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import Foundation

class PasswordReset: NSObject {
    var userEmail: String?
    
    init(email: String?){
        self.userEmail = email
    }
    
    func hasNoEmptyFields() -> Bool {
        if !userEmail!.isEmpty{
            return true
        }else{
            return false
        }
    }
    
    //ADD IN AN ERROR CHECK TO MAKE SURE AN ACTUAL EMAIL IS ENTERED
    
    func passwordResetAlert() throws {
        guard hasNoEmptyFields() else{
            throw Error.EmptyField
        }
    }
    
}