//
//  BillingViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 6/14/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class BillingViewController: UIViewController {
    
    var shippingSameAsBilling: Bool = false
    
    private var redirectURLString: String?
    
    @IBOutlet weak var firstNameBox: UITextField!
    
    @IBOutlet weak var lastNameBox: UITextField!
    
    @IBOutlet weak var companyNameBox: UITextField!
    
    @IBOutlet weak var countryBox: UITextField!
    
    @IBOutlet weak var address1Box: UITextField!
    
    @IBOutlet weak var address2Box: UITextField!
    
    @IBOutlet weak var cityBox: UITextField!
    
    @IBOutlet weak var stateBox: UITextField!
    
    @IBOutlet weak var zipBox: UITextField!
    
    @IBOutlet weak var emailBox: UITextField!

    @IBOutlet weak var phoneBox: UITextField!
    
    @IBOutlet weak var checkBoxButton: UIButton!
    
    @IBOutlet weak var shippingOrPayPalButton: UIButton!
    
    @IBAction func checkBoxToggle(_ sender: Any) {
        shippingSameAsBilling = !shippingSameAsBilling
        
        DispatchQueue.main.async {
            if(self.shippingSameAsBilling)
            {
                self.checkBoxButton.setImage(UIImage(named: "checkbox_checked")!, for: .normal)
                
                self.shippingOrPayPalButton.titleLabel?.text = "Proceed to PayPal"
                
                self.shippingOrPayPalButton.frame = CGRect(x: 121, y: 571, width: 133, height: 30)
                
                self.shippingOrPayPalButton.setImage(UIImage(named: "PayPal_button_backgroud-1"), for: .normal)
                
                self.shippingOrPayPalButton.titleLabel?.textColor = UIColor.white
            }
            else
            {
                self.checkBoxButton.setImage(UIImage(named: "checkbox_unchecked")!, for: .normal)
                
                self.shippingOrPayPalButton.titleLabel?.text = "Continue"
                
                self.shippingOrPayPalButton.frame = CGRect(x: 154, y: 571, width: 67, height: 30)
                
                self.shippingOrPayPalButton.setBackgroundImage(UIImage(named: "picker_button_background-2"), for: .normal)
                
                self.shippingOrPayPalButton.titleLabel?.textColor = UIColor.white
                
            }
        }
        
    }
    
    
    @IBAction func goToPayPalOrShipping(_ sender: Any) {
        //Start filling in billing data
        ShoppingCart.instance.order?.billing.firstName = firstNameBox.text!
        
        ShoppingCart.instance.order?.billing.lastName = lastNameBox.text!
        
        ShoppingCart.instance.order?.billing.companyName = companyNameBox.text!
        
        ShoppingCart.instance.order?.billing.country = countryBox.text!
        
        ShoppingCart.instance.order?.billing.address1 = address1Box.text!
        
        ShoppingCart.instance.order?.billing.address2 = address2Box.text!
        
        ShoppingCart.instance.order?.billing.city = cityBox.text!
        
        ShoppingCart.instance.order?.billing.state = stateBox.text!
        
        ShoppingCart.instance.order?.billing.postalCode = zipBox.text!
        
        ShoppingCart.instance.order?.billing.email = emailBox.text!
        
        ShoppingCart.instance.order?.billing.phone = phoneBox.text!
        //End of filling billing data
        
        if(shippingSameAsBilling)
        {
            //Start filling shipping data
        
            ShoppingCart.instance.order?.shipping.firstName = firstNameBox.text!
            
            ShoppingCart.instance.order?.shipping.lastName = lastNameBox.text!
            
            ShoppingCart.instance.order?.shipping.companyName = companyNameBox.text!
            
            ShoppingCart.instance.order?.shipping.country = countryBox.text!
            
            ShoppingCart.instance.order?.shipping.address1 = address1Box.text!
            
            ShoppingCart.instance.order?.shipping.address2 = address2Box.text!
            
            ShoppingCart.instance.order?.shipping.city = cityBox.text!
            
            ShoppingCart.instance.order?.shipping.state = stateBox.text!
            
            ShoppingCart.instance.order?.shipping.postalCode = zipBox.text!
            //End of filling shipping data
            
            
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
            
            let json = JSON(data: encodedString!).dictionaryObject
            
            Alamofire.request(orderURLString, method: .post, parameters: json, encoding: JSONEncoding.default, headers: headers).authenticate(usingCredential: credential).responseJSON{ response in debugPrint(response)
                
                let postResponseJSON = JSON(response.result.value!)
                ShoppingCart.instance.order?.orderID = postResponseJSON["id"].intValue
                
            }
            
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
                }
                
                
            }

            if(resultCode == 200)
            {
                performSegue(withIdentifier: "billingToPayment", sender: sender)
            }
            else
            {
                //Display error message
            }
           
            
        }
        else
        {
            performSegue(withIdentifier: "goToShipping", sender: sender)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as? WebPaymentViewController
        
        if segue.identifier == "billingToPayment"
        {
            viewController?.redirectURLString = redirectURLString
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if(shippingSameAsBilling)
        {
            checkBoxButton.setImage(UIImage(named: "checkbox_checked")!, for: .normal)
            
            shippingOrPayPalButton.titleLabel?.text = "Proceed to Payment"
            
            shippingOrPayPalButton.frame = CGRect(x: 108.5, y: 571, width: 158, height: 30)
            
        shippingOrPayPalButton.setBackgroundImage(UIImage(named: "PayPal_button_backgroud-1"), for: .normal)
            
            shippingOrPayPalButton.titleLabel?.textColor = UIColor.white
            
            
        }
        else
        {
            checkBoxButton.setImage(UIImage(named: "checkbox_unchecked")!, for: .normal)
            
            shippingOrPayPalButton.titleLabel?.text = "Continue"
            
            shippingOrPayPalButton.frame = CGRect(x: 154, y: 571, width: 67, height: 30)
            
            shippingOrPayPalButton.setBackgroundImage(UIImage(named: "picker_button_background-2"), for: .normal)
            
            shippingOrPayPalButton.titleLabel?.textColor = UIColor.white
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
