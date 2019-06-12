//
//  CartViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 4/2/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit


class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cartTableData:[CartData] = []
    
    var fullTotal:Double = 0
    
    @IBOutlet weak var cartTable: UITableView!
    
    @IBOutlet weak var checkoutButton: UIButton!
    
    @IBOutlet weak var clearCartButton: UIButton!

    @IBOutlet weak var fullTotalLabel: UILabel!
    
    @IBAction func checkOut(_ sender: Any) {
        
        if(cartTableData.count > 0)
        {
            performSegue(withIdentifier: "checkout", sender: sender)
        }
        else
        {
            let alertController = UIAlertController(title: "Cannot Check Out", message: "Cart is empty", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    
    @IBAction func clearCart(_ sender: Any) {
        
        ShoppingCart.instance.cartItems = []
        cartTableData = []
        
        self.fullTotal = 0
        for i in 0...self.cartTableData.count - 1
        {
            let itemPrice = Double(self.cartTableData[i].item.price)! * Double(self.cartTableData[i].quantity)
            let itemTax = itemPrice * ShoppingCart.instance.taxRate
            
            self.fullTotal += itemPrice + itemTax
        }
        
        self.fullTotalLabel.text = "Total: $" + String(format:"%04.2f", self.fullTotal)
        
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
        
        let taxDouble = priceDouble! * quantityDouble * ShoppingCart.instance.taxRate
        
        cell.taxLabel.text = "Tax: $" + String(format:"%04.2f",taxDouble)
        
        let totalDouble = priceDouble! * quantityDouble + taxDouble
        
        cell.totalLabel.text = "Total: $" + String(format:"%04.2f",totalDouble)
        
        let backGroundView = UIView()
        
        backGroundView.backgroundColor = UIColor.init(displayP3Red: 255/255, green: 147/255, blue: 0/255, alpha: 255/255)
        
        cell.selectedBackgroundView = backGroundView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cartTableData.remove(at: indexPath.row)
        ShoppingCart.instance.cartItems.remove(at: indexPath.row)
        
        self.fullTotal = 0
        for i in 0...self.cartTableData.count - 1
        {
            let itemPrice = Double(self.cartTableData[i].item.price)! * Double(self.cartTableData[i].quantity)
            let itemTax = itemPrice * ShoppingCart.instance.taxRate
            
            self.fullTotal += itemPrice + itemTax
        }
        
        self.fullTotalLabel.text = "Total: $" + String(format:"%04.2f", self.fullTotal)
        
        self.cartTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        cartTable.delegate = self
        
        cartTable.dataSource = self
        
        cartTableData = ShoppingCart.instance.cartItems
        
        let taxUrlString = "https://brunchandslay.com/wp-json/wc/v2/taxes"
        
        let key = "ck_1f524b00ccc62c462dac098fee0a21c6ed852712"
        
        let pass = "cs_1b0196f008f336d3a4a7870e5e858abe3d208734"
        let credential = URLCredential(user: key, password: pass, persistence: .forSession)
        
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: key, password: pass){
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        
        Alamofire.request(taxUrlString, headers: headers).authenticate(usingCredential: credential).responseJSON
            {
                response in debugPrint(response)
                
                if let json = response.value
                {
                    print("JSON: \(json)")
                    let jsonValues = JSON(json)
                    
                    let taxRate = (jsonValues[0]["rate"].double)! / 100.0
                    
                    ShoppingCart.instance.taxRate = taxRate
                    
                    self.fullTotal = 0
                    for i in 0...self.cartTableData.count - 1
                    {
                        let itemPrice = Double(self.cartTableData[i].item.price)! * Double(self.cartTableData[i].quantity)
                        let itemTax = itemPrice * ShoppingCart.instance.taxRate
                        
                        self.fullTotal += itemPrice + itemTax
                    }
                    
                    self.fullTotalLabel.text = "Total: $" + String(format:"%04.2f", self.fullTotal)
                        
                        
                    DispatchQueue.main.async {
                        self.cartTable.reloadData()
                    }
                }
        }
        
        
        
    }
    
    
}
