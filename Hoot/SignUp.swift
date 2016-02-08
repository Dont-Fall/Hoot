//
//  SignUp.swift
//  Hoot
//
//  Created by Christopher Frost and Zack Cuomo on 1/11/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import Foundation

class SignUp: NSObject {
    var userName: String?
    var userEmail: String?
    var password: String?
    var confirmPassword: String?
    var userSchool: String?
    var userSubject: String?
    var userPoints: Int?
    var userCurrentGroupCode: String?
    var emailVerified: Bool?
    
    init(uName: String, email: String, pass: String, confirmPass: String, school: String, subject: String, points: Int, groupCode: String){
        self.userName = uName
        self.userEmail = email
        self.password = pass
        self.confirmPassword = confirmPass
        self.userSchool = school
        self.userSubject = "Math"
        self.userPoints = 0
        self.userCurrentGroupCode = ""
        self.emailVerified = false
    }
    
    func signUpUser() throws -> Bool {
        guard hasNoEmptyFields() else{
            throw Error.EmptyField
        }
        guard hasValidEmail() else{
            throw Error.InvalidEmail
        }
        guard validatePasswordsMatch() else{
            throw Error.PasswordsDoNotMatch
        }
        guard checkPasswordSufficientComplexity() else{
            throw Error.InvalidPassword
        }
        guard storeSuccessfulSignUp() else{
            throw Error.UserNameTaken
        }
        return true
        
    }
    
    func hasNoEmptyFields() -> Bool {
        if !userName!.isEmpty && !userEmail!.isEmpty && !password!.isEmpty && !confirmPassword!.isEmpty && !userSchool!.isEmpty {
            return true
        }else{
            return false
        }
    }
    
    func hasValidEmail() -> Bool {
        let emailEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = userEmail!.rangeOfString(emailEX, options: .RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
    
    func validatePasswordsMatch() -> Bool {
        if (password! == confirmPassword!){
            return true
        }else{
            return false
        }
    }
    
    func checkPasswordSufficientComplexity() -> Bool {
        let capitalLetterRegEx = ".*[A-Z]+.*"
        let textTest = NSPredicate(format: "SELF MATCHES %@", capitalLetterRegEx)
        let capitalResult = textTest.evaluateWithObject(password!)
        print("Capital Letter: \(capitalResult)")
        
        let numberRegEx = ".*[0-9]+.*"
        let textTest2 = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        let numberResult = textTest2.evaluateWithObject(password!)
        print("Number Included: \(numberResult)")
        
        let lengthResult = password!.characters.count >= 8
        print("Passed Length: \(lengthResult)")
        
        return capitalResult && numberResult && lengthResult
    }
    
    func storeSuccessfulSignUp() -> Bool {
        var success = false
        let user = PFUser()
        
        user.username = userName!
        user.email = userEmail!
        user.password = password!
        user["school"] = userSchool!
        user["points"] = userPoints!
        user["subject"] = userSubject!
        user["currentGroupCode"] = userCurrentGroupCode!
        user["emailVerified"] = emailVerified!
        
        
        do {
            try user.signUp()
        }catch {
            print("Error in storing successful signup.")
        }
        
        success = user.isNew
        return success
    }
    
}