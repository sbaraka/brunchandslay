//
//  Order.swift
//  Brunch and Slay
//
//  Created by Noah on 6/13/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import Foundation

struct Order
{
    var orderID: Int
    var paymentMethod: String
    var paymentMethodTitle: String
    var billing: Billing
    var shipping: Shipping
    var shippingLines: [ShippingLine]
}
