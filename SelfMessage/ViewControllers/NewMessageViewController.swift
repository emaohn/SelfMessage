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

class NewMessageViewController: UIViewController{
    
    @IBOutlet weak var wholeView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var senderTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var pickerData = [[String]]()
    var timeInterval = 5.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
        setup()
        hideKeyboardWhenTappedAround()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            if didAllow {
                UserDefaults.standard.set(true, forKey: "notificationsEnabled")
            } else {
                UserDefaults.standard.set(false, forKey: "notificationsEnabled")
            }
        })
    }
    
    func setup() {
        //changing the UI, corners rounded
        wholeView.layer.cornerRadius = 6
        titleView.layer.cornerRadius = 6
        infoView.layer.cornerRadius = 6
        timeView.layer.cornerRadius = 6
        cancelButton.layer.cornerRadius = 6
        doneButton.layer.cornerRadius = 6
        
        doneButton.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        
        timePicker.minuteInterval = 1

    }
    
    func reset() {
        messageTextView.text = ""
        senderTextField.text = ""
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if senderTextField.text != "" && messageTextView.text != "" {
            NotificationCenter.default.post(name: NSNotification.Name("ToggleNewMessageView"), object: nil)
            
            let message = CoreDataHelper.newMessage()
            message.sender = senderTextField.text
            message.message = messageTextView.text
            message.sendTime = Date()
            
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            
//            guard let sender = senderTextField.text, let message2 = messageTextView.text else { return }
            content.title = NSString.localizedUserNotificationString(forKey: senderTextField.text ?? "", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: messageTextView.text, arguments: nil)
            
            let interval = timePicker.date
            let components = Calendar.current.dateComponents([.hour, .minute], from: interval)
            let hour = components.hour
            let minutes = components.minute
            
            let numSeconds = (hour! * 60 * 60) + (minutes! * 60)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(numSeconds), repeats: false)
            let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
            
            center.add(request)
            
            reset()
            
            CoreDataHelper.saveMessage()
        } else {
            // Create the alert controller
            let alertController = UIAlertController(title: "Fill in all blanks before sending", message: "", preferredStyle: UIAlertController.Style.alert)
            //alertController.view.tintColor = .tcDarkGrey
            
            let subview = (alertController.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
            subview.backgroundColor = UIColor(red: 254/255, green: 254/255, blue: 254/255, alpha: 1)
            
            // Create the actions
            let okAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default) {
                UIAlertAction in
            }
            
            // Add the actions
            alertController.addAction(okAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
        }
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
        
        if senderTextField.text != "" && messageTextView.text != "" {
            doneButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        }
    }
    
}
