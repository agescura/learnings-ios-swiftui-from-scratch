import UIKit

var greeting = "Hello, playground"
print(greeting)

func basics() {
    let firstName = "Matt"
    var lastName: String
    
    if firstName == "Matt" {
      //let
        lastName = "Galloway"
    } else if firstName == "Ray" {
       //let
        lastName = "Wenderlich"
    } else {
        lastName = ""
    }
    
    let fullName = firstName + " " + lastName

    print(fullName)
}

basics()
