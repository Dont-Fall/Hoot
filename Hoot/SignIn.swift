//
//  SignIn.swift
//  Hoot
//
//  Created by Christopher Frost on 1/11/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import Foundation

class SignIn {
    var userName: String?
    var password: String?
    
    init(user: String, pass: String) {
        self.userName = user
        self.password = pass
    }
    
    func signInUser() throws {
        guard hasEmptyFields() else{
            throw Error.EmptyField
        }
        guard checkUserCredentials() else{
            throw Error.IncorrectSignIn
        }
        
    }
    
    func hasEmptyFields() -> Bool {
        if !userName!.isEmpty && !password!.isEmpty {
            return true
        }
        return false
    }
    
    func checkUserCredentials() -> Bool {
        do{
            try PFUser.logInWithUsername(userName!, password: password!)
        }catch {
            print("Error in checkUserCredentials")
        }
        if (PFUser.currentUser() != nil){
            return true
        }
        return false
    }
    
}
