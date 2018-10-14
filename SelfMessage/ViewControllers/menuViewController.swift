//
//  menuViewController.swift
//  SelfMessage
//
//  Created by Emmie Ohnuki on 10/13/18.
//  Copyright © 2018 Emmie Ohnuki. All rights reserved.
//

import Foundation
import UIKit
class menuViewController: UIViewController {
    var newMessageViewOpen: Bool = false
    var favoritedMessages: FavoritedMessages?
    var favorites = [Message]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var newMessageContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newMessageContainerViewBottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newMessageContainerView.superview?.bringSubviewToFront(newMessageContainerView)
        NotificationCenter.default.addObserver(self, selector: #selector(toggleNewMessageView), name: NSNotification.Name("ToggleNewMessageView"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        newMessageContainerViewBottomConstraint.constant = -550
        
       let faves = CoreDataHelper.retrieveFavoritedMessages()
        
        if faves.count != 0 {
            favoritedMessages = faves[0]
            favorites = favoritedMessages?.message?.array as! [Message]
        } else {
            favoritedMessages = CoreDataHelper.newFavoriteMessages()
            favorites = favoritedMessages?.message?.array as! [Message]
        }
    }
    
    @objc func toggleNewMessageView() {
        if newMessageViewOpen{
            newMessageContainerViewBottomConstraint.constant = -550
            newMessageViewOpen = false
        } else {
            newMessageContainerViewBottomConstraint.constant = 15
            newMessageViewOpen = true
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension menuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favorites.count != 0 {
            return favorites.count + 1
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "createMessageTableViewCell", for: indexPath)
            return cell
        }
        
        if favorites.count != 0 {
            let message = favorites[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageTableViewCell") as! messageTableViewCell
           // cell.senderLabel.text = message.sender
            cell.messageLabel.text = message.message
            return cell
        }

        return tableView.dequeueReusableCell(withIdentifier: "noFavoritesTableViewCell")!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if favorites.count == 0 {
            return 120
        }
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            toggleNewMessageView()
        } else {
            if favorites.count != 0 {
                toggleNewMessageView()
                let userInfo = ["message": favorites[indexPath.row - 1]]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetInfo"), object: nil, userInfo: userInfo)
//                NotificationCenter.default.post(name: NSNotification.Name("GetInfo"), object: nil)
                
            }
        }
    }
}
