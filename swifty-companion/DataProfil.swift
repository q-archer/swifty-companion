//
//  DataProfil.swift
//  swifty-companion
//
//  Created by Quentin ARCHER on 9/14/16.
//  Copyright © 2016 Quentin ARCHER. All rights reserved.
//

import UIKit

class DataProfil {
    var email: String
    var phone: String
    var level: String
    var location: String
    var image: String?
    
    // MARK: Initialization
    
    init(email: String, phone: String, level: String, location: String, image: String?)
    {
        self.email = email;
        self.phone = phone;
        self.level = level;
        self.location = location;
        self.image = image;
    }
}