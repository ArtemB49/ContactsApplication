//
//  UserInfoVC.swift
//  ContactsApp
//
//  Created by Артем Б on 06.11.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import UIKit

class UserInfoVC: UIViewController {
    
    var user: User?
    
    let service = RandomUserService()

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = user{
            name.text = "\(user.firstName.firstUppercased) \(user.lastName.firstUppercased)"
            date.text = user.date
            address.text = "\(user.city.firstUppercased) \(user.street.firstUppercased)"
            phone.text = user.phone
            email.text = user.email
            getImage()
        }
        
    }
    
    func getImage(){
        if let urlString = user?.photoLarge{
            service.fetchImage(by: urlString, completion: { image in
                DispatchQueue.main.async {
                    self.photo.image = image
                }
                
            })
        }
    }





}
