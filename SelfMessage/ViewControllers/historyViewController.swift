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
    
    var message = Message()
    
    override func viewDidLoad () {
        super.viewDidLoad()
        
        message = CoreDataHelper.newMessage()
        message?.sender =
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyTableViewCell", for: indexPath) as! HistoryTableViewCell
        
        let message =
        cell.fromLabel.text = "Grace"
        cell.messageLabel.text = message
        cell.timestampLabel.text = "time sent"
        
        
        return cell
    }
    
    @IBAction func favButtonPressed(_ sender: Any) {
        
    }
    
}
