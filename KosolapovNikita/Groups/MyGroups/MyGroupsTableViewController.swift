//
//  AllCommunities.swift
//  L1_KosolapovNikita
//
//  Created by Nikita on 29/03/2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift
import FirebaseDatabase

class MyGroupsController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    let user = [FirebaseGroup]()
    let ref = Database.database().reference(withPath: "user")
    
    var token: NotificationToken?
    var groups: Results<MyGroup>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "MyGroupsTableViewCell", bundle: nil), forCellReuseIdentifier: "MyGroupsTableViewCell")
        
        pairTableWithRealm()
        MakeRequest.shared.getMyGroupsList()
    }
    
    func addGroupToFirebaseDatabase() {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let group = groups![indexPath.row]
            let userId = Session.shared.userId
            let userGroup = FirebaseGroup(groupId: group.id, name: group.name, activity: group.activity)
            let userRef = self.ref.child("user_id: \(String(userId))")
            let groupRef = userRef.child("group_id: \(String(userGroup.groupId))")
            groupRef.setValue(userGroup.toAnyObject())
        }
    }
    
    func pairTableWithRealm() {
        guard let realm = try? Realm() else { return }
        groups = realm.objects(MyGroup.self)
        token = groups!.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                break
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
}

// MARK: - Table view data source

extension MyGroupsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // number os sections equals 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0 // numbers of rows equals array.count
    }
    
    // set image and title to the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsTableViewCell", for: indexPath) as! MyGroupsTableViewCell
        
        guard let group = groups?[indexPath.row] else { return UITableViewCell() }
        
        cell.configure(myGroup: group)
        
        return cell
    }
}

extension MyGroupsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addGroupToFirebaseDatabase()
    }
}
