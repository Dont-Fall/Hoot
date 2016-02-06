//
//  AskQuestion.swift
//  Hoot
//
//  Created by Zack Cuomo on 1/15/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.

import Foundation

class AddSchool: NSObject {
    
    var schoolState: String?
    var schoolName: String?
//    let alert = UIAlertController()
    
    init(state: String, name: String){
        self.schoolState = state
        self.schoolName = name
    }
    
    func hasNoEmptyFields() -> Bool{
        if !schoolState!.isEmpty && !schoolName!.isEmpty{
            return true
        }else{
            return false
        }
    }
    
    
    func addSchoolAlert() throws {
        guard hasNoEmptyFields() else{
            throw Error.EmptyField
        }

    }
}