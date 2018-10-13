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
    var favorites: [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let favoriteMessages = UserDefaults.standard.value(forKey: "favoriteMessages") as? [Message] else {return }
        self.favorites = favoriteMessages
    }
    
    @IBOutlet weak var tableView: UITableView!
}

extension menuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let favorites = self.favorites {
            return favorites.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = favorites?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageTableViewCell") as! messageTableViewCell
    }
    
    
}
