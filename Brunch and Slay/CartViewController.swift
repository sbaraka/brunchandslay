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

    
    
    @IBAction func clearCart(_ sender: Any) {
        
        ShoppingCart.instance.cartItems = []
        cartTableData = []
        cartTable.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTable.dequeueReusableCell(withIdentifier: "checkOutCell") as! CartCell
        
        
        if(cartTableData[indexPath.row].item.name.count > 34)
        {
            cell.nameLabel.text = cartTableData[indexPath.row].item.name.prefix(31) + "..."
        }
        else
        {
            cell.nameLabel.text = cartTableData[indexPath.row].item.name
        }
        
        let imageURL = URL(string: cartTableData[indexPath.row].item.imageURLString)
        
        cell.previewImage.kf.setImage(with: imageURL)
        
        let priceDouble = Double(cartTableData[indexPath.row].item.price)
        
        cell.priceLabel.text = "Price: $" + String(format:"%04.2f",priceDouble!)
        
        let quantityString = String(cartTableData[indexPath.row].quantity)
        
        cell.quantityLabel.text = "Quantity: " + quantityString
        
        let quantityDouble = Double(cartTableData[indexPath.row].quantity)
        
        let totalDouble = priceDouble! * quantityDouble
        
        cell.totalLabel.text = "Total: $" + String(format:"%04.2f",totalDouble)
        
        let backGroundView = UIView()
        
        backGroundView.backgroundColor = UIColor.init(displayP3Red: 255/255, green: 147/255, blue: 0/255, alpha: 255/255)
        
        cell.selectedBackgroundView = backGroundView
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        cartTable.delegate = self
        
        cartTable.dataSource = self
        
        cartTableData = ShoppingCart.instance.cartItems
        
        DispatchQueue.main.async {
            self.cartTable.reloadData()
        }
        
      
        
    }
    
    
}
