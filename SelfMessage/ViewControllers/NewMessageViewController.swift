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

class NewMessageViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 25
        case 1,2:
            return 60
        default:
            return 0
        }
    }
    
    
    
    @IBOutlet weak var wholeView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var senderTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var timePicker2: UIPickerView!
    
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var timeInterval = 5.0
    var hour = 0
    var minutes = 0
    var seconds = 0
    var pickerData: [[String]] = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
        setup()
        timePicker2.delegate = self
        timePicker2.dataSource = self
        hideKeyboardWhenTappedAround()
        
        pickerData = [["1", "2", "3", "4"],
                      ["1", "2", "3", "4"],
                      ["1", "2", "3", "4"]]
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            if didAllow {
                UserDefaults.standard.set(true, forKey: "notificationsEnabled")
            } else {
                UserDefaults.standard.set(false, forKey: "notificationsEnabled")
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(getInfo), name: NSNotification.Name("GetInfo"), object: nil)
    }
    
    func setup() {
        //changing the UI, corners rounded
        wholeView.layer.cornerRadius = 10
        titleView.layer.cornerRadius = 10
        infoView.layer.cornerRadius = 10
        timeView.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        doneButton.layer.cornerRadius = 10
        messageTextView.layer.cornerRadius = 10
        doneButton.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        
//        timePicker.minuteInterval = 1

    }
    
    @objc func getInfo(_ notification: Notification){
        if let message = notification.userInfo?["message"] as? Message {
           messageTextView.text = message.message
            headerLabel.text = "Favorited Message"
            
        }
    }
    
    func reset() {
        messageTextView.text = ""
        senderTextField.text = ""
        headerLabel.text = "Create A New Message"
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
            
//            let interval = timePicker.date
//            let components = Calendar.current.dateComponents([.hour, .minute, .second], from: interval)
//            let hour = components.hour
//            let minutes = components.minute
//            let seconds = components.second
//
//            let numSeconds = (hour! * 60 * 60) + (minutes! * 60) + (seconds!)
            
            
            func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
                return pickerView.frame.size.width/3
            }
            
            func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
                switch component {
                case 0:
                    return "\(pickerData[0][row]) Hour"
                case 1:
                    return "\(pickerData[1][row]) Minute"
                case 2:
                    return "\(pickerData[2][row]) Second"
                default:
                    return ""
                }
            }
            func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
                switch component {
                case 0:
                    hour = row
                case 1:
                    minutes = row
                case 2:
                    seconds = row
                default:
                    break;
                }
            }
            
            let numSeconds = hour * 60 * 60 + minutes * 60 + seconds
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
