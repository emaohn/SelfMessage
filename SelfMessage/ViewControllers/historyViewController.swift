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
    var newMessageViewOpen = false
    var messages = [Message]() {
        didSet {
            messagesTableView.reloadData()
        }
    }
    
    var favoritedMessages: FavoritedMessages?
    @IBOutlet weak var popupBottomConstraint: NSLayoutConstraint!
    
    var favoriteMessageArray: [Message] = []
    
    @IBOutlet weak var messagesTableView: UITableView!
    
    override func viewDidLoad () {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(toggleNewMessageView2), name: NSNotification.Name("ToggleNewMessageView2"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messages = CoreDataHelper.retrieveMessage()
        getFaves()
    }
    
    func getFaves() {
        let faves = CoreDataHelper.retrieveFavoritedMessages()
        if faves.count != 0 {
            favoritedMessages = faves[0]
            favoriteMessageArray = favoritedMessages?.message?.array as! [Message]
        } else {
            favoritedMessages = CoreDataHelper.newFavoriteMessages()
            favoriteMessageArray = favoritedMessages?.message?.array as! [Message]
        }
    }
    
    @objc func toggleNewMessageView2() {
        if newMessageViewOpen{
            popupBottomConstraint.constant = -550
            newMessageViewOpen = false
        } else {
            popupBottomConstraint.constant = 15
            newMessageViewOpen = true
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
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
                for i in 0...self.favoriteMessageArray.count {
                    let favoriteMessage = self.favoriteMessageArray[i]
                    if cell.senderLabel.text == favoriteMessage.sender && cell.messageLabel.text == favoriteMessage.message {
                        self.favoriteMessageArray.remove(at: i)
                        self.favoritedMessages?.removeFromMessage(message)
                        break
                    }
                }
            } else {
                cell.favoriteButton.isSelected = true
                message.favorite = true
                self.favoriteMessageArray.append(message)
                self.favoritedMessages?.addToMessage(message)
            }
            CoreDataHelper.saveMessage()
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toggleNewMessageView2()
        let userInfo = ["message": messages[indexPath.row]]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SendInfo"), object: nil, userInfo: userInfo)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedMessage = messages[indexPath.row]
            CoreDataHelper.deleteMessage(message: deletedMessage)
            CoreDataHelper.saveMessage()
            messages = CoreDataHelper.retrieveMessage()
            getFaves()
        }
    }
}
