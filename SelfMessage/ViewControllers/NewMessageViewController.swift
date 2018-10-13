//
//  NewMessageViewController.swift
//  SelfMessage
//
//  Created by Emmie Ohnuki on 10/13/18.
//  Copyright © 2018 Emmie Ohnuki. All rights reserved.
//

import Foundation
import UIKit
class NewMessageViewController: UIViewController {
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var senderTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var setTimeTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleNewMessageView"), object: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleNewMessageView"), object: nil)
    }
    
    
}
