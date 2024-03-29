//
//  ShopDetailViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 4/16/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit

class ShopDetailViewController: UIViewController {
    
    var shopData:ProductData?
    
    @IBOutlet weak var previewImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UITextView!
    
    @IBOutlet weak var quantityBox: UITextField!
    
    @IBOutlet weak var quantityStepper: UIStepper!
    
    @IBAction func addToCart(_ sender: Any) {
        var itemInCart: Bool = false
        var location: Int = -1
        
        if(ShoppingCart.instance.cartItems.count > 0)
        {
            for i in 0...ShoppingCart.instance.cartItems.count - 1
            {
                if(ShoppingCart.instance.cartItems[i].item.id == shopData?.id)
                    {
                        itemInCart = true
                        location = i
                        break
                    }
            }
        }
        
        if(itemInCart)
        {
            
            if(quantityStepper.value > 0)
            {
                ShoppingCart.instance.cartItems[location].quantity += Int(quantityStepper.value)
            }
        }
        else
        {
            if(quantityStepper.value > 0)
            {
                let tempItem = CartData(item: shopData!, quantity: Int(quantityStepper.value))
            
            ShoppingCart.instance.cartItems.append(tempItem)
            }
            
        }
        
        
    }
    
    
    @IBAction func stepQuantity(_ sender: Any) {
        quantityBox.text = String(format: "%01.0f",quantityStepper.value)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let imageURL = URL(string: (shopData?.imageURLString)!)
        
        previewImage.kf.setImage(with: imageURL)
        nameLabel.text = shopData?.name
        
        let priceDouble = Double((shopData?.price)!)
        let formattedPrice = String(format: "%04.2f", priceDouble!)
        
        priceLabel.text = "Price: $" + formattedPrice
        
        let sanitizedDescription = (shopData?.description)!.replacingOccurrences(of: "<p>", with: "\n").replacingOccurrences(of: "</p>", with: "").replacingOccurrences(of: "<div class=\"grammarly-disable-indicator\"></div>", with: "")
        
        descriptionLabel.text = sanitizedDescription
        
        quantityBox.text = String(format: "%01.0f",quantityStepper.value)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
