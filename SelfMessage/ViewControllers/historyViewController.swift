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
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyTableViewCell", for: indexPath) as! HistoryTableViewCell
        
        let message = messages[indexPath.row]
        cell.fromLabel.text = message.sender
        cell.messageLabel.text = message.message
        cell.timestampLabel.text = message.sendTime?.convertToString() //you probs have to write your own to string function
    
        return cell
    }
    
    @IBAction func favButtonPressed(_ sender: Any) {
        
    }
    
}
