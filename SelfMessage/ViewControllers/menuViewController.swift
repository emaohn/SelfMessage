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
        
        guard let favoriteMessages = UserDefaults.standard.value(forKey: "favoriteMessages") as? [Message] else {return }
        self.favorites = favoriteMessages
    }
    
    @IBAction func newMessageButtonPressed(_ sender: Any) {
        toggleNewMessageView()
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
            return favorites.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if favorites.count != 0 {
            let message = favorites[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageTableViewCell") as! messageTableViewCell
            cell.senderLabel.text = message.sender
            cell.messageLabel.text = message.message
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "noFavoritesTableViewCell")!
        
    }
}
