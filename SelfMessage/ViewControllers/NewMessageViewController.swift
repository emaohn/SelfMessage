//
//  NewMessageViewController.swift
//  SelfMessage
//
//  Created by Emmie Ohnuki on 10/13/18.
//  Copyright © 2018 Emmie Ohnuki. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NewMessageViewController: UIViewController {
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var senderTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var timeIntervalLabel: UILabel!
    @IBOutlet weak var timeStepper: UIStepper!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
        hideKeyboardWhenTappedAround()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            if didAllow {
                UserDefaults.standard.set(true, forKey: "notificationsEnabled")
            } else {
                UserDefaults.standard.set(false, forKey: "notificationsEnabled")
            }
        })
    }
    
    func reset() {
        timeStepper.value = 5
        messageTextView.text = ""
        senderTextField.text = ""
        timeIntervalLabel.text = "5 min"
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if let sender = senderTextField.text,
            let body = messageTextView.text {
            NotificationCenter.default.post(name: NSNotification.Name("ToggleNewMessageView"), object: nil)
            
             let message = CoreDataHelper.newMessage()
            message.sender = sender
            message.message = body
            message.sendTime = Date()
            
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: sender, arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: body, arguments: nil)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeStepper.value * 60, repeats: false)
            let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
            
            center.add(request)
            
            reset()
            
            CoreDataHelper.saveMessage()
        } else {
            // Create the alert controller
            let alertController = UIAlertController(title: "Please fill in all blank spaces", message: "", preferredStyle: UIAlertController.Style.alert)
            //alertController.view.tintColor = .tcDarkGrey
            
            let subview = (alertController.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
            subview.backgroundColor = UIColor(red: 254/255, green: 254/255, blue: 254/255, alpha: 1)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
            }
            
            // Add the actions
            alertController.addAction(okAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func stepper(_ sender: UIStepper) {
        timeIntervalLabel.text = "\(String(Int(sender.value))) min"
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleNewMessageView"), object: nil)
        reset()
    }
}

extension NewMessageViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewMessageViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
