//
//  ShippingViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 6/14/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ShippingViewController: UIViewController {
    
    private var redirectURLString: String?
    
    @IBOutlet weak var firstNameBox: UITextField!
    
    @IBOutlet weak var lastNameBox: UITextField!
    
    @IBOutlet weak var companyBox: UITextField!
    
    @IBOutlet weak var countryBox: UITextField!
    
    @IBOutlet weak var address1Box: UITextField!
    
    @IBOutlet weak var address2Box: UITextField!
    
    @IBOutlet weak var cityBox: UITextField!
    
    @IBOutlet weak var stateBox: UITextField!
    
    @IBOutlet weak var zipBox: UITextField!
    
    @IBAction func openPayPal(_ sender: Any) {
        //Start filling shipping data
        ShoppingCart.instance.order?.shipping.firstName = firstNameBox.text!
        
        ShoppingCart.instance.order?.shipping.lastName = lastNameBox.text!
        
        ShoppingCart.instance.order?.shipping.companyName = companyBox.text!
        
        ShoppingCart.instance.order?.shipping.country = countryBox.text!
        
        ShoppingCart.instance.order?.shipping.address1 = address1Box.text!
        
        ShoppingCart.instance.order?.shipping.address2 = address2Box.text!
        
        ShoppingCart.instance.order?.shipping.city = cityBox.text!
        
        ShoppingCart.instance.order?.shipping.state = stateBox.text!
        
        ShoppingCart.instance.order?.shipping.postalCode = zipBox.text!
        //End of filling shipping data
        
        UserDefaults.standard.set(firstNameBox.text!, forKey: "firstNameShipping")
        
        UserDefaults.standard.set(lastNameBox.text!, forKey: "lastNameShipping")
        
        UserDefaults.standard.set(companyBox.text!, forKey: "companyNameShipping")
        
        UserDefaults.standard.set(address1Box.text!, forKey: "address1Shipping")
        
        UserDefaults.standard.set(address2Box.text!, forKey: "address2Shipping")
        
        UserDefaults.standard.set(cityBox.text!, forKey: "cityShipping")
        
        UserDefaults.standard.set(stateBox.text!, forKey: "stateShipping")
        
        UserDefaults.standard.set(zipBox.text!, forKey: "zipShipping")
        
        UserDefaults.standard.set(countryBox.text!, forKey: "countryShipping")
        
        
        do{
            let orderURLString = "https://brunchandslay.com/wp-json/wc/v2/orders"
            
            let processPaymentURLString = "https://brunchandslay.com/wp-json/wc/v2/process_payment"
            
            let key = "ck_1f524b00ccc62c462dac098fee0a21c6ed852712"
            
            let pass = "cs_1b0196f008f336d3a4a7870e5e858abe3d208734"
            
            let credential = URLCredential(user: key, password: pass, persistence: .forSession)
            
            var headers: HTTPHeaders = [:]
            
            if let authorizationHeader = Request.authorizationHeader(user: key, password: pass){
                headers[authorizationHeader.key] = authorizationHeader.value
            }
            
            let orderString = ShoppingCart.instance.makeOrderText()
            
            let encodedString = (orderString as NSString).data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)
            
            let json = try JSON(data: encodedString!).dictionaryObject
            
            Alamofire.request(orderURLString, method: .post, parameters: json, encoding: JSONEncoding.default, headers: headers).authenticate(usingCredential: credential).responseJSON{ response in debugPrint(response)
                
                let postResponseJSON = JSON(response.result.value!)
                ShoppingCart.instance.order?.orderID = postResponseJSON["id"].intValue
                ShoppingCart.instance.clearCart()
                
                let paymentJSON: JSON = [
                    "order_id": (ShoppingCart.instance.order?.orderID)!,
                    "payment_method": ShoppingCart.instance.payMethod
                ]
                
                var resultCode: Int?
                
                Alamofire.request(processPaymentURLString, method: .post, parameters: paymentJSON.dictionaryObject, encoding: JSONEncoding.default, headers: headers).authenticate(usingCredential: credential).responseJSON{ response in debugPrint(response)
                    
                    let postResponseJSON = JSON(response.result.value!)
                    
                    resultCode = postResponseJSON["code"].intValue
                    
                    if(resultCode == 200)
                    {
                        self.redirectURLString = postResponseJSON["data"]["redirect"].stringValue
                        self.performSegue(withIdentifier: "shippingToPayment", sender: sender)
                    }
                    else
                    {
                        //Display error message
                    }
                    
                }
                
            }
        }
        catch let error as NSError{
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shippingToPayment"
        {
            let viewController = segue.destination as? WebPaymentViewController
            
            
            viewController?.redirectURLString = redirectURLString
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let firstName = UserDefaults.standard.string(forKey: "firstNameShipping")
        {
            firstNameBox.text = firstName
            lastNameBox.text = UserDefaults.standard.string(forKey: "lastNameShipping")
            companyBox.text = UserDefaults.standard.string(forKey: "companyNameShipping")
            address1Box.text = UserDefaults.standard.string(forKey: "address1Shipping")
            address2Box.text = UserDefaults.standard.string(forKey: "address2Shipping")
            cityBox.text = UserDefaults.standard.string(forKey: "cityShipping")
            stateBox.text = UserDefaults.standard.string(forKey: "stateShipping")
            zipBox.text = UserDefaults.standard.string(forKey: "zipShipping")
            countryBox.text = UserDefaults.standard.string(forKey: "countryShipping")
        }
        
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
