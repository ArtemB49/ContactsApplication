//
//  User.swift
//  ContactsApp
//
//  Created by Артем Б on 06.11.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {
    var firstName: String = ""
    var lastName: String = ""
    var photoSmall: String = ""
    var photoLarge: String = ""
    var phone: String = ""
    var date: String = ""
    var email: String = ""
    var city: String = ""
    var street: String = ""

    
    init(json: JSON) {
        self.firstName = json["name"]["first"].stringValue
        self.lastName = json["name"]["last"].stringValue
        self.photoSmall = json["picture"]["thumbnail"].stringValue
        self.photoLarge = json["picture"]["large"].stringValue
        self.date = json["dob"].stringValue
        self.phone = json["phone"].stringValue
        self.email = json["email"].stringValue
        self.city = json["location"]["city"].stringValue
        self.street = json["location"]["street"].stringValue
    }

    init(first: String, last: String, photoSmall: String,
         photoLarge: String, phone: String, date: String,
         email: String, city: String, street: String){
        self.firstName = first
        self.lastName = last
        self.photoSmall = photoSmall
        self.photoLarge = photoLarge
        self.date = date
        self.phone = phone
        self.email = email
        self.city = city
        self.street = street
    }
    
    
    
}

