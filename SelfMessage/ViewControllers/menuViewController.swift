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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if favorites.count != 0 {
                return favorites.count
            }
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 35))
        view.backgroundColor = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1)
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: 35))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.black
        
        switch section {
        case 1:
            label.text = "Favorite Messages"
        default:
            label.text = ""
        }
    
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "createMessageTableViewCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }
        
        if favorites.count != 0 {
            let message = favorites[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageTableViewCell") as! messageTableViewCell
           // cell.senderLabel.text = message.sender
            cell.messageLabel.text = message.message
            cell.selectionStyle = .none
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
        if indexPath.section == 0 && indexPath.row == 0 {
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
