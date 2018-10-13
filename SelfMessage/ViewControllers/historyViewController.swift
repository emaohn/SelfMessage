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
    
    var favoritedMessages = [Message]()
    
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
        var message = messages[indexPath.row]
        if let sender = message.sender, let body = message.message, let sendTime = message.sendTime {
            cell.senderLabel.text = sender
            cell.messageLabel.text = body
            cell.timeStampLabel.text = sendTime.convertToString()
           
            if message.favorite == true {
                cell.favoriteButton.isSelected = true
            } else {
                cell.favoriteButton.isSelected = false
            }
        }
        
        cell.favoriteButtonTouched = {(cell1) in guard tableView.indexPath(for: cell1) != nil
            else { return }
            
            if !cell.favoriteButton.isSelected {
                cell.favoriteButton.isSelected = false
                message.favorite = false
                for i in 0...self.favoritedMessages.count {
                    let favoriteMessage = self.favoritedMessages[i]
                    if cell.senderLabel.text == favoriteMessage.sender && cell.messageLabel.text == favoriteMessage.message {
                        self.favoritedMessages.remove(at: i)
                    }
                }
            } else {
                cell.favoriteButton.isSelected = true
                message.favorite = true
                self.favoritedMessages.append(message)
            }
        
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
}
