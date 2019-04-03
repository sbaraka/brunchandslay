//
//  User.swift
//  BrunchAndSlayiOS
//
//  Created by Noah on 3/29/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import Foundation

class User {
    var id = -1
    var name = ""
    var email = ""
    private var passwordHash = -1
    var settings = [String]()
    private var levelOfAccess = -1
    var purchases = [[Int]]()
    var cart = [[Int]]()
    
    func checkPassword(password:String)
    {
        //hash password and compare with passwordHash
    }
    
    func updatePassword(newPassword:String)
    {
        //hash newPassword and set passwordHash to the resulting value
    }
    
    
}
