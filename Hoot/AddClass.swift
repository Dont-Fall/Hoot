//
//  AddClass.swift
//  Hoot
//
//  Created by Christopher Frost on 2/6/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import Foundation

class AddClass: NSObject {
    var className: String?
    var classCourse: String?
    var classCode: String?
    
    init(name: String?, course: String?, code: String?){
        self.className = name
        self.classCourse = course
        self.classCode = code
    }
    
    func hasNoEmptyFields() -> Bool {
        if !className!.isEmpty && !classCourse!.isEmpty && !classCode!.isEmpty{
            return true
        }else{
            return false
        }
    }
    
    func courseSufficientLength() -> Bool{
        if classCourse!.characters.count < 4{
            return false
        }else{
            return true
        }
    }
    
    func codeSufficientLenght() -> Bool{
        if classCode!.characters.count < 4{
            return false
        }else{
            return true
        }
    }
    
    
    func addClassAlert() throws {
        guard hasNoEmptyFields() else{
            throw Error.EmptyField
        }
        guard courseSufficientLength() else{
            throw Error.InsufficientCourseLength
        }
        guard codeSufficientLenght() else{
            throw Error.InsufficientCodeLength
        }
    }
}