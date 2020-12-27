//
//  ReloadTableViewOperation.swift
//  KosolapovNikita
//
//  Created by Nikita on 01.08.2020.
//  Copyright © 2020 Nikita Kosolapov. All rights reserved.
//

import Foundation
import UIKit

class ReloadTableViewController: Operation {
    var controller: MyFriendsViewController
    
    init(controller: MyFriendsViewController) {
        self.controller = controller
    }
    
    override func main() {
        guard let parseData = dependencies.first as? ParseData else { return }
        controller.users = parseData.outputData
        controller.handleFriends(users: parseData.outputData)
        
        OperationQueue.main.addOperation {
            self.controller.tableView.reloadData()
        }
    }
}
