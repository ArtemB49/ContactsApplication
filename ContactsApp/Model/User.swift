//
//  User.swift
//  ContactsApp
//
//  Created by Артем Б on 06.11.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation
import Foundation
import SwiftyJSON

class User{
    var firstName: String = ""
    var lastName: String = ""
    var photoSmall: String = ""
    var photoLarge: String = ""
    var phone: String = ""
    var date: String = ""
    var email: String = ""
    var bornInfo:String = ""
    
    
    init(json: JSON) {
        self.firstName = json["name"]["first"].stringValue
        self.lastName = json["name"]["last"].stringValue
        self.photoSmall = json["picture"]["thumbnail"].stringValue
        self.photoLarge = json["picture"]["large"].stringValue
        self.date = json["dob"].stringValue
        self.phone = json["phone"].stringValue
        self.email = json["email"].stringValue
        self.bornInfo = json["location"]["city"].stringValue
    }
}
