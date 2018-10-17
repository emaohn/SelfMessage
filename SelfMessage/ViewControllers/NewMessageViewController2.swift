//
//  NewMessageViewController2.swift
//  SelfMessage
//
//  Created by Emmie Ohnuki on 10/14/18.
//  Copyright © 2018 Emmie Ohnuki. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NewMessageViewController2: UIViewController {
   
    
    
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
    
    var hour = 0
    var minutes = 0
    var seconds = 5
    let pickerData = [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24],
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59],
    [5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
        setup()
        timePicker2.dataSource = self
        timePicker2.delegate = self
        hideKeyboardWhenTappedAround()

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            if didAllow {
                UserDefaults.standard.set(true, forKey: "notificationsEnabled")
            } else {
                UserDefaults.standard.set(false, forKey: "notificationsEnabled")
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(SendInfo), name: NSNotification.Name("SendInfo"), object: nil)
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
    }
    
    @objc func SendInfo(_ notification: Notification){
        if let message = notification.userInfo?["message"] as? Message {
            messageTextView.text = message.message
            senderTextField.text = message.sender
            headerLabel.text = "Resend Previous Message"
        }
    }
    
    func reset() {
        messageTextView.text = ""
        senderTextField.text = ""
        headerLabel.text = "Resend Previous Message"
        
        hour = 0
        minutes = 0
        seconds = 5
        
        timePicker2.reloadAllComponents()
        timePicker2.selectRow(0, inComponent: 0, animated: true)
        timePicker2.selectRow(0, inComponent: 1, animated: true)
        timePicker2.selectRow(0, inComponent: 2, animated: true)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if senderTextField.text != "" && messageTextView.text != "" {
            NotificationCenter.default.post(name: NSNotification.Name("ToggleNewMessageView2"), object: nil)
            
            let message = CoreDataHelper.newMessage()
            message.sender = senderTextField.text
            message.message = messageTextView.text
            message.sendTime = Date()
            
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            
            content.title = NSString.localizedUserNotificationString(forKey: senderTextField.text ?? "", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: messageTextView.text, arguments: nil)
            
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
        NotificationCenter.default.post(name: NSNotification.Name("ToggleNewMessageView2"), object: nil)
        reset()
    }
}

extension NewMessageViewController2: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(pickerData[component][row]) hours"
        case 1:
            return "\(pickerData[component][row]) min"
        case 2:
            return "\(pickerData[component][row]) sec"
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            hour = pickerData[component][row]
        case 1:
            minutes = pickerData[component][row]
        case 2:
            seconds = pickerData[component][row]
        default:
            print("fail")
        }
    }
}

extension NewMessageViewController2 {
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
