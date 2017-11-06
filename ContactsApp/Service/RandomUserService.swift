//
//  RandomUserService.swift
//  ContactsApp
//
//  Created by Артем Б on 06.11.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class RandomUserService {
    
    func loadUser(completion: @escaping ([User]?) -> Void ){
        let utilityQueue = DispatchQueue.global(qos: .utility)
        let url = URL(string: "https://randomuser.me/api/?format=json&results=10&inc=name,location,email,phone,picture,id,dob")
        Alamofire.request(url!)
            .responseData(queue:  utilityQueue){ response in
                if let data = response.value{
                    let json = JSON(data: data)
                    let user = json["results"].flatMap{User(json:$0.1)}
                    completion(user)
                }
                
        }
    }
}
