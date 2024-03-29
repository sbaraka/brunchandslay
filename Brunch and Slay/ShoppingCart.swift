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
    
    var order: Order?
    
    var cartItems: [CartData]
    
    var taxRate: Double
    
    private init()
    {
        self.order = Order(orderID: -1, paymentMethod: "paypal", paymentMethodTitle: "PayPal", billing: Billing(firstName: "", lastName: "", companyName: "", address1: "", address2: "", city: "", state: "", postalCode: "", country: "", email: "", phone: ""), shipping: Shipping(firstName: "", lastName: "", companyName: "", address1: "", address2: "", city: "", state: "", postalCode: "", country: ""), shippingLines: [])
        self.cartItems = []
        self.taxRate = 0
    }
    
    func clearCart()
    {
        cartItems = []
    }
    
    func makeOrderText() -> String
    {
        var lineItemsSubString = "[ "
        
        for i in 0...cartItems.count - 1
        {
            lineItemsSubString += "{ \"product_id\": " + String(cartItems[i].item.id) + ", \"quantity\": " + String(cartItems[i].quantity) + "}"
            
            if(i < cartItems.count - 1)
            {
              lineItemsSubString += ", "
            }

        }
        
        lineItemsSubString += "], "
        
        var shippingLinesSubString = "[ "
        
        let shippingLinesCount = (order?.shippingLines.count ?? 0)
        
        if (shippingLinesCount > 0)
        {
            for i in 0...shippingLinesCount - 1
            {
                shippingLinesSubString += "{ \"method_id\": \"" + (order?.shippingLines[i].methodId)! + "\", \"method_title\": \"" + (order?.shippingLines[i].methodTitle)! + "\", \"total\": " + String((order?.shippingLines[i].total)!) + " }"
                
                if(i < shippingLinesCount - 1)
                {
                   shippingLinesSubString += ", "
                }
            }
        
        }
            
        shippingLinesSubString += "] "
        
        let orderString = "{ \"payment_method\": \"" + (order?.paymentMethod)! + "\", " + "\"payment_method_title\": \"" + (order?.paymentMethodTitle)! + "\", " + "\"set_paid\": false, " + "\"billing\": { \"first_name\": \"" + (order?.billing.firstName)! + "\", \"last_name\": \"" + (order?.billing.lastName)! + "\", \"address_1\": \"" + (order?.billing.address1)! + "\", \"address_2\": \"" + (order?.billing.address2)! + "\", \"city\": \"" + (order?.billing.city)! + "\", \"state\": \"" + (order?.billing.state)! + "\", \"postcode\": \"" + (order?.billing.postalCode)! + "\", \"country\": \"" + (order?.billing.country)! + "\", \"email\": \"" + (order?.billing.email)! + "\", \"phone\": \"" + (order?.billing.phone)! + "\" }, \"shipping\": { \"first_name\": \"" + (order?.shipping.firstName)! + "\", \"last_name\": \"" + (order?.shipping.lastName)! + "\", \"address_1\": \"" + (order?.shipping.address1)! + "\", \"address_2\": \"" + (order?.shipping.address2)! + "\", \"city\": \"" + (order?.shipping.city)! + "\", \"state\": \"" + (order?.shipping.state)! + "\", \"postcode\": \"" + (order?.shipping.postalCode)! + "\", \"country\": \"" + (order?.shipping.country)! + "\" }, \"line_items\": " + lineItemsSubString + "\"shipping_lines\": " + shippingLinesSubString + "}"
        
        
        return orderString
    }
}

