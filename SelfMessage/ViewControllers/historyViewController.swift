//
//  historyViewController.swift
//  SelfMessage
//
//  Created by Emmie Ohnuki on 10/13/18.
//  Copyright © 2018 Emmie Ohnuki. All rights reserved.
//

import Foundation
import UIKit


class historyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var messages = [Message]() {
        didSet {
            messagesTableView.reloadData()
        }
    }
    
    @IBOutlet weak var messagesTableView: UITableView!
    
    override func viewDidLoad () {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messages = CoreDataHelper.retrieveMessage()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "previousMessageTableViewCell", for: indexPath) as! previousMessageTableViewCell
        let message = messages[indexPath.row]
        if let sender = message.sender, let body = message.message, let sendTime = message.sendTime {
            cell.senderLabel.text = sender
            cell.messageLabel.text = body
            cell.timeStampLabel.text = sendTime.convertToString()
        }
        
        cell.favoriteButtonTouched = {(cell) in guard tableView.indexPath(for: cell) != nil
            else { return }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
}
