//
//  ViewController.swift
//  ContactsApp
//
//  Created by Артем Б on 06.11.2017.
//  Copyright © 2017 Артем Б. All rights reserved.
//

import UIKit

class UserTVC: UITableViewController {
    
    let service = RandomUserService()
    let database = Database.instance
    var users: [User]?{
        didSet{
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Обновление" )
        refreshControl?.addTarget(self, action: #selector(loadUsersNet(_:)), for: .valueChanged)
        if Reachability.isConnectedToNetwork(){
            self.loadUsersNet(self)
        } else {
            self.loadUsersDB()
        }
        
    }
    
    //MARK TableView Delegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let user = users?[indexPath.row]{
            cell.imageView?.image = getImage(by: user.photoSmall)
            cell.textLabel?.text = "\(user.firstName.firstUppercased) \(user.lastName.firstUppercased)"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRow = indexPath.row
        if lastRow == self.users!.count - 1{
            addUsers(at: lastRow + 1)
        }
    }
    
    //MARK: User Image
    
    func getImage(by urlString: String) -> UIImage {
        guard Reachability.isConnectedToNetwork() else {
            return UIImage(named: "user")!
        }
        do{
            if let url = URL(string: urlString){
                let data = try Data(contentsOf: url)
                return UIImage(data: data)!
            }
        } catch {
            print(error)
        }
        return UIImage(named: "user")!
    }
    
    //MARK: Load User List
    
    @objc func loadUsersNet(_ sender: Any) {
        service.loadUser(completion: {result in
            DispatchQueue.main.async {
                self.users = result
                self.refreshControl?.endRefreshing()
                self.database.insert(users: self.users!)
            }
            
        })
    }
    
    func loadUsersDB()  {
        database.loadUsers(completion: { (result) in
            DispatchQueue.main.async {
                self.users = result
                self.refreshControl?.endRefreshing()
            }
        })        
    }
    
    func addUsers(at lastRow: Int) {
        service.loadUser(completion: { (result) in
            DispatchQueue.main.async {
                for user in result!{
                    self.users?.append(user)
                    self.tableView.reloadData()
                    
                }
            }            
        })
    }
    
    //MARK Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "userInfo"){
            if let cell = sender as? UITableViewCell,
                let userInfoVC = segue.destination as? UserInfoVC,
                let row = tableView.indexPath(for: cell)?.row{
                    userInfoVC.user = self.users![row]
            }
        }
    }



}

