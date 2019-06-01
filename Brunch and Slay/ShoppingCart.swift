//
//  ShoppingCart.swift
//  Brunch and Slay
//
//  Created by Noah on 6/1/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import Foundation

class ShoppingCart
{
    
    static let instance = ShoppingCart()
    
    var cartItems: [CartData]
    
    private init()
    {
        self.cartItems = []
    }
    
}

