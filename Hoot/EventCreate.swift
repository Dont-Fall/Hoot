//
//  AskQuestion.swift
//  Hoot
//
//  Created by Zack Cuomo on 1/15/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.

import Foundation

class EventCreate: NSObject {
    
    var userEvent: String?
    var userLocation: String?
    var eventDate: NSDate?
//    let alert = UIAlertController()
    
    init(event: String, location: String, date: NSDate){
        self.userEvent = event
        self.userLocation = location
        self.eventDate = date
    
    }
    
    func hasNoEmptyFields() -> Bool{
        if !userEvent!.isEmpty && !userLocation!.isEmpty{
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