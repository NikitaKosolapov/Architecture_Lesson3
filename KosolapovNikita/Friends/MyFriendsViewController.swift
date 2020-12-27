//
//  MyCommunitiesViewController.swift
//  KosolapovNikita
//
//  Created by Nikita on 07/04/2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class MyFriendsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Realm properties
    var token: NotificationToken?
    var users = [User]()
    let queue = OperationQueue()
    
    // Processed values
    var sortedUsers = [User]()
    var usersInAlphabeticalOrder = [[User]]()
    var firstLettersOfNames = [Character]()
    
    // Search bar properties
    var filteredUsers = [User]()
    var searchBarIsEmpty: Bool {
        guard let text = searchBar.text else { return false }
        return text.isEmpty
    }
    private var searchBarIsActive: Bool = false
    private var isFiltering: Bool {
        return !searchBarIsEmpty && searchBarIsActive
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MyFriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "MyFriendsTableViewCell")
        
        let initialUrl = "https://api.vk.com/method" // define initial url
        let accessToken = Session.shared.token // get current token
        
        let parameters: Parameters = ["access_token": accessToken, "fields": "photo_200", "v": 5.103]
        let path = "/friends.get"
        let url = initialUrl + path
        
        let request =  AF.request(url, method: .get, parameters: parameters)
        
        let getDataOperation = GetDataOperation(request: request)
        let parseData = ParseData()
        let reloadTable = ReloadTableViewController(controller: self)
        
        parseData.addDependency(getDataOperation)
        reloadTable.addDependency(parseData)
        
        queue.addOperation(getDataOperation)
        queue.addOperation(parseData)
        queue.addOperation(reloadTable)
        
        // Define delegates of table view and search bar
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self

    }
    
    func handleFriends(users: [User]) {

        guard let tableView = self.tableView else { return }

        // Sort users by last name
        sortedUsers = users.sorted{$0.lastName < $1.lastName}

        // Get array of friends in alphabetical order
        for user in sortedUsers {
            if firstLettersOfNames.contains(user.lastName.first!) {
                usersInAlphabeticalOrder[usersInAlphabeticalOrder.count - 1].append(user)
            } else {
                firstLettersOfNames.append(user.lastName.first!)
                usersInAlphabeticalOrder.append([user])
            }
        }
        DispatchQueue.main.async {
         tableView.reloadData()
        }
    }
}

// MARK: UITableViewDataSource

extension MyFriendsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return 1
        } else {
            return usersInAlphabeticalOrder.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredUsers.count
        } else {
            return usersInAlphabeticalOrder[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendsTableViewCell", for: indexPath) as! MyFriendsTableViewCell// declare cell
        
        // Define interactive animator
        
        cell.userImageView.alpha = 0
        
        let interactiveAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
            
            UIView.animate(withDuration: 1,
                           delay: 0.1,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0.6,
                           options: [],
                           animations: {
                            cell.frame.origin.x -= 100
            })
        })
        
        UIView.animate(withDuration: 1,
                       animations: {
                        cell.userImageView.alpha = 1
        })
        
        interactiveAnimator.startAnimation()
        
        // Configurate cells
        var user: User
        
        if isFiltering { // if searchBar activated
            user = filteredUsers[indexPath.row]
        } else {
            user = usersInAlphabeticalOrder[indexPath.section][indexPath.row]
        }
        
        cell.selectionStyle = .none
        
        cell.configure(user: user)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFiltering {
            return .none
        } else {
            return "\(self.firstLettersOfNames[section])"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProfilePhotos" { // check segue identifier
            if let indexPath = self.tableView.indexPathForSelectedRow { // get the index path to the controller's selected row
                let photoController = segue.destination as! PhotoController // get the link to the controller
                
                var user: User
                
                if isFiltering { // if search bar is active
                    user = filteredUsers[indexPath.row]
                } else {
                    user = usersInAlphabeticalOrder[indexPath.section][indexPath.row]
                }
                photoController.ownerId = user.id // set profile photo
            }
        }
    }
}

extension MyFriendsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowProfilePhotos", sender: nil)
    }
}

// MARK: UISearchBarDelegate

extension MyFriendsViewController: UISearchBarDelegate {
    
    private func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBarIsActive = true;
    }
    
    private func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBarIsActive = false;
    }
    
    private func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBarIsActive = false;
    }
    
    private func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBarIsActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredUsers = users.filter({(user: User) in
            return user.lastName.lowercased().contains(searchText.lowercased())
        })
        if(filteredUsers.count == 0){
            searchBarIsActive = false;
        } else {
            searchBarIsActive = true;
        }
        tableView.reloadData()
    }
}



