//
//  Database.swift
//  ContactsApp
//
//  Created by Артем Б on 04.11.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import Foundation
import GRDB

class Database {
    
    static let instance = Database()
    
    private init(){}
    
    var dbQueue: DatabaseQueue?{
        get{
            let dbPath = self.databaseFilePath()
            let isDatabase = UserDefaults.standard.bool(forKey: "isDB")
            if isDatabase {
                return try! DatabaseQueue(path: dbPath)
            } else {
                return createDatabase(by: dbPath)
            }
            
        }
    }
    
    let DATABASE_NAME = "database.sqlite"
    
    func databaseFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let dir = paths[0] as NSString
        return dir.appendingPathComponent(DATABASE_NAME)
    }
    
    func createDatabase(by path: String) -> DatabaseQueue {
        
        do{
            let databaseQueue = try DatabaseQueue(path: path)
            try databaseQueue.inDatabase{ db in
                try db.execute("""
                    CREATE TABLE IF NOT EXISTS users (
                    first_name TEXT PRIMARY KEY,
                    last_name TEXT,
                    photo_small TEXT,
                    photo_large TEXT,
                    date TEXT,
                    city TEXT,
                    street TEXT,
                    phone TEXT,
                    email TEXT)
                    """)
            }
            UserDefaults.standard.set(true, forKey: "isDB")
            return databaseQueue
        } catch {
            print("Error")
            return try! DatabaseQueue(path: path)
        }
    }
    
    func insert(users: [User]) {
        if let databaseQueue = self.dbQueue{
            for user in users {
                do{
                    try databaseQueue.inDatabase{ db in
                        try db.execute("""
                            INSERT INTO users ( first_name, last_name, photo_small, photo_large, date, city, street, phone, email)
                            VALUES (:first, :last, :photo_small, :photo_large, :date, :city, :street, :phone, :email)
                            """,
                                       arguments: ["first": user.firstName, "last": user.lastName,
                                                   "photo_small": user.photoSmall, "photo_large": user.photoLarge,
                                                   "date": user.date, "city": user.city, "street": user.street,
                                                   "phone": user.phone, "email": user.email])
                    }
                    
                } catch {
                    print("Error occurent, when users insert in databse")
                }
            }
        }
    }
    
    func loadUsers(completion: @escaping ([User]?) -> Void){
        DispatchQueue.global(qos: .utility).async {
            
            do{
                var users:[User] = []
                if let databaseQueue = self.dbQueue{
                    try databaseQueue.inDatabase{ db in
                        let rows = try Row.fetchCursor(db, "SELECT * FROM users")
                        while let row = try rows.next() {
                            let user = User(first: row["first_name"],
                                            last: row["last_name"],
                                            photoSmall: row["photo_small"],
                                            photoLarge: row["photo_large"],
                                            phone: row["date"],
                                            date: row["city"],
                                            email: row["street"],
                                            city: row["phone"],
                                            street: row["email"])
                            users.append(user)
                        }
                    }
                }
                completion(users)
            } catch {
                print("Error load users from database")
            }
        }
    }
    
}
