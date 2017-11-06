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
        refreshControl?.addTarget(self, action: #selector(loadUsers(_:)), for: .valueChanged)
        self.loadUsers(self)
    }
    
    //MARK TableView Delegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshControl?.beginRefreshing()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let row = indexPath.row
        cell.imageView?.image = getImage(by: users![row].photoSmall)
        cell.textLabel?.text = "\(users![row].firstName) \(users![row].lastName)"
        return cell
    }
    
    //MARK: User Image
    
    func getImage(by urlString: String) -> UIImage {
        do{
            if let url = URL(string: urlString){
                let data = try Data(contentsOf: url)
                return UIImage(data: data)!
            }
        } catch {
            return UIImage(named: "user")!
        }
        return UIImage(named: "user")!
    }
    
    //MARK: Load User List
    
    @objc func loadUsers(_ sender: Any) {
        service.loadUser(completion: {result in
            DispatchQueue.main.async {
                self.users = result
                self.refreshControl?.endRefreshing()
                self.database.insert(users: self.users!)
            }
            
        })
    }



}

