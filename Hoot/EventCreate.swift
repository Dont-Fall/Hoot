//
//  AskQuestion.swift
//  Hoot
//
//  Created by Christopher Frost on 1/13/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//  Assistance from Zack Cuomo

import Foundation

class EventCreate: NSObject {
    
    var userEvent: String?
    var userLocation: String?
    var eventDate: String?
//    let alert = UIAlertController()
    
    init(event: String, location: String, date: String){
        self.userEvent = event
        self.userLocation = location
        self.eventDate = date
    
    }
    
    func hasNoEmptyFields() -> Bool{
        if !userEvent!.isEmpty && !userLocation!.isEmpty && !eventDate!.isEmpty{
            return true
        }else{
            return false
        }
    }
    
    func eventSufficientLength() -> Bool{
        if userEvent!.characters.count < 5{
            return false
        }else{
            return true
        }
    }
    
    func locationSufficientLenght() -> Bool{
        if userLocation!.characters.count < 3{
            return false
        }else{
            return true
        }
    }

    
    func eventAlert() throws {
        guard hasNoEmptyFields() else{
            throw Error.EmptyField
        }
        guard eventSufficientLength() else{
            throw Error.InsufficientEventLength
        }
        guard locationSufficientLenght() else{
            throw Error.InsufficientLocationLength
        }
    }
}