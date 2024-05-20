//
//  basicos.swift
//  Tutorial
//
//  Created by Manuel Mauricio Gomez Gallo on 9/05/24.
//

import Foundation

func basics() {
    let firstName = "Matt"
    var lastName: String?
    
    if firstName == "Matt" {
        lastName = "Galloway"
    } else if firstName == "Ray" {
        lastName = "Wenderlich"
    }
    
    let fullName = firstName + " " + lastName!

}
