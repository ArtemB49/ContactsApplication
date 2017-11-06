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
                    photo TEXT,
                    date TEXT,
                    born_info TEXT,
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
                            INSERT INTO users ( first_name, last_name, photo, date, born_info, phone, email)
                            VALUES (:first, :last, :photo, :date, :born, :phone, :email)
                            """,
                                       arguments: ["first": user.firstName,
                                                   "last": user.lastName, "photo": user.photo,
                                                   "date": user.date, "born": user.bornInfo,
                                                   "phone": user.phone, "email": user.email])
                    }
                    
                } catch {
                    print("Error occurent, when users insert in databse")
                }
            }
        }
    }
    
}
