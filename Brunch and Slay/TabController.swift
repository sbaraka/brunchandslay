//
//  TabController.swift
//  Brunch and Slay
//
//  Created by Noah on 4/4/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit
import Foundation

class TabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 140/255, blue: 0, alpha: 1)], for: .selected)
        
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        
    }
    
}
