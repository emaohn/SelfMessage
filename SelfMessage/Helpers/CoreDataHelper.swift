//
//  CoreDataHelper.swift
//  SelfMessage
//
//  Created by Emmie Ohnuki on 10/13/18.
//  Copyright © 2018 Emmie Ohnuki. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct CoreDataHelper {
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistanceContainer = appDelegate.persistentContainer
        let context = persistanceContainer.viewContext
        
        return context
    }()
    
    static func newMessage() -> Message {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        return message
    }
    
    static func saveMessage() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    static func delete(message: Message) {
        context.delete(message)
        saveMessage()
    }
    
    static func retrieveMessage() -> [Message] {
        do {
            let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
            let results = try context.fetch(fetchRequest)
            return results.reversed()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
            return []
        }
    }
}
