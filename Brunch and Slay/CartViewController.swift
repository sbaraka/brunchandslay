//
//  CartViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 4/2/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cartTableData:[CartData] = []
    
    @IBOutlet weak var cartTable: UITableView!
    
    
    @IBOutlet weak var checkoutButton: UIButton!
    
    @IBOutlet weak var clearCartButton: UIButton!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTable.dequeueReusableCell(withIdentifier: "checkOutCell") as! CartCell
        
        cell.nameLabel.text = cartTableData[indexPath.row].name
        
        cell.previewImage.image = cartTableData[indexPath.row].preview
        
        cell.priceLabel.text = "Price: " + String(format:"%.2f",cartTableData[indexPath.row].price)
        
        cell.quantityLabel.text = "Quantity: " + String(cartTableData[indexPath.row].quantity)
        
        cell.totalLabel.text = "Total: " + String(format:"%.2f",cartTableData[indexPath.row].price * Double(cartTableData[indexPath.row].quantity))
        
        
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
}
