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
    
    @IBOutlet weak var shippingOrPayPalWidth: NSLayoutConstraint!
    
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
                
                self.shippingOrPayPalButton.setTitle("Proceed to PayPal", for: .normal)
                
                //self.shippingOrPayPalButton.frame = CGRect(x: 108.5, y: 571, width: 158, height: 30)
                
                //self.shippingOrPayPalButton.sizeToFit()
                
                self.shippingOrPayPalWidth.constant = 158
                self.shippingOrPayPalButton.setBackgroundImage(UIImage(named: "PayPal_button_backgroud-1"), for: .normal)
                
                
                self.shippingOrPayPalButton.setTitleColor(UIColor.white, for: .normal)
            }
            else
            {
                self.checkBoxButton.setImage(UIImage(named: "checkbox_unchecked")!, for: .normal)
                
                self.shippingOrPayPalButton.setTitle("Continue", for: .normal)
                
                //self.shippingOrPayPalButton.frame = CGRect(x: 154, y: 571, width: 67, height: 30)
                
                //self.shippingOrPayPalButton.sizeToFit()
                
                self.shippingOrPayPalWidth.constant = 67
                self.shippingOrPayPalButton.setBackgroundImage(UIImage(named: "picker_button_background-2"), for: .normal)
                
                self.shippingOrPayPalButton.setTitleColor(UIColor.black, for: .normal)
                
            }
        }
        
    }
    
    
    @IBAction func goToPayPalOrShipping(_ sender: Any) {
        
        if(ShoppingCart.instance.cartItems.count > 0)
        {
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
                do{
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
                    
                    
                    UserDefaults.standard.set(firstNameBox.text!, forKey: "firstNameBilling")
                    
                    UserDefaults.standard.set(lastNameBox.text!, forKey: "lastNameBilling")
                    
                    UserDefaults.standard.set(companyNameBox.text!, forKey: "companyNameBilling")
                    
                    UserDefaults.standard.set(address1Box.text!, forKey: "address1Billing")
                    
                    UserDefaults.standard.set(address2Box.text!, forKey: "address2Billing")
                    
                    UserDefaults.standard.set(cityBox.text!, forKey: "cityBilling")
                    
                    UserDefaults.standard.set(stateBox.text!, forKey: "stateBilling")
                    
                    UserDefaults.standard.set(zipBox.text!, forKey: "zipBilling")
                    
                    UserDefaults.standard.set(countryBox.text!, forKey: "countryBilling")
                    
                    UserDefaults.standard.set(emailBox.text!, forKey: "emailBilling")
                    
                    UserDefaults.standard.set(phoneBox.text!, forKey: "phoneBilling")
                    
                    let orderURLString = "https://brunchandslay.com/wp-json/wc/v2/orders"
                    
                    let processPaymentURLString = "https://brunchandslay.com/wp-json/wc/v2/process_payment"
                    
                    let key = "ck_1f524b00ccc62c462dac098fee0a21c6ed852712"
                    
                    let pass = "cs_1b0196f008f336d3a4a7870e5e858abe3d208734"
                    
                    let authorizedOrder = orderURLString + "?consumer_key=" + key + "&consumer_secret=" + pass
                    
                    let authorizedPayment = processPaymentURLString + "?consumer_key=" + key + "&consumer_secret=" + pass
                    
                    let credential = URLCredential(user: key, password: pass, persistence:  .forSession)
                    
                    var headers: HTTPHeaders = [:]
                    
                    if let authorizationHeader = Request.authorizationHeader(user: key, password: pass){
                        headers[authorizationHeader.key] = authorizationHeader.value
                    }
                    
                    
                    let orderString = ShoppingCart.instance.makeOrderText()
                    
                    let encodedString = (orderString as NSString).data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)
                    
                    let json = try JSON(data: encodedString!).dictionaryObject
                    
                    Alamofire.request(authorizedOrder, method: .post, parameters: json, encoding: JSONEncoding.default, headers: headers).authenticate(usingCredential: credential).responseJSON{ response in debugPrint(response)
                        
                        let postResponseJSON = JSON(response.result.value!)
                        ShoppingCart.instance.order?.orderID = postResponseJSON["id"].intValue
                        ShoppingCart.instance.clearCart()
                        
                        let paymentJSON: JSON = [
                            "order_id": (ShoppingCart.instance.order?.orderID)!,
                            "payment_method": (ShoppingCart.instance.order?.paymentMethod)!
                        ]
                        
                        var resultCode: Int?
                        
                        Alamofire.request(authorizedPayment, method: .post, parameters: paymentJSON.dictionaryObject, encoding: JSONEncoding.default, headers: headers).authenticate(usingCredential: credential).responseJSON{ response in debugPrint(response)
                            
                            let postResponseJSON = JSON(response.result.value!)
                            
                            resultCode = postResponseJSON["code"].intValue
                            
                            if(resultCode == 200)
                            {
                                ShoppingCart.instance.clearCart()
                                 
                                self.redirectURLString = postResponseJSON["data"]["redirect"].stringValue
                                self.performSegue(withIdentifier: "billingToPayment", sender: sender)
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
            else
            {
                performSegue(withIdentifier: "goToShipping", sender: sender)
            }
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
            
            shippingOrPayPalButton.setTitle("Proceed to PayPal", for: .normal)
            
            //shippingOrPayPalButton.frame = CGRect(x: 108.5, y: 571, width: 158, height: 30)
            
            //shippingOrPayPalButton.sizeToFit()
            
            shippingOrPayPalWidth.constant = 158
            
            shippingOrPayPalButton.setBackgroundImage(UIImage(named: "PayPal_button_backgroud-1"), for: .normal)
            
            shippingOrPayPalButton.setTitleColor(UIColor.white, for: .normal)
            
        }
        else
        {
            checkBoxButton.setImage(UIImage(named: "checkbox_unchecked")!, for: .normal)
            
            shippingOrPayPalButton.setTitle("Continue", for: .normal)
            
            //shippingOrPayPalButton.frame = CGRect(x: 154, y: 571, width: 67, height: 30)
            
            //shippingOrPayPalButton.sizeToFit()
            
            shippingOrPayPalWidth.constant = 67
            
            shippingOrPayPalButton.setBackgroundImage(UIImage(named: "picker_button_background-2"), for: .normal)
            
            shippingOrPayPalButton.setTitleColor(UIColor.black, for: .normal)
            
        }
        
        if let firstName = UserDefaults.standard.string(forKey: "firstNameBilling")
        {
            firstNameBox.text = firstName
            lastNameBox.text = UserDefaults.standard.string(forKey: "lastNameBilling")
            companyNameBox.text = UserDefaults.standard.string(forKey: "companyNameBilling")
            address1Box.text = UserDefaults.standard.string(forKey: "address1Billing")
            address2Box.text = UserDefaults.standard.string(forKey: "address2Billing")
            cityBox.text = UserDefaults.standard.string(forKey: "cityBilling")
            stateBox.text = UserDefaults.standard.string(forKey: "stateBilling")
            zipBox.text = UserDefaults.standard.string(forKey: "zipBilling")
            countryBox.text = UserDefaults.standard.string(forKey: "countryBilling")
            emailBox.text = UserDefaults.standard.string(forKey: "emailBilling")
            phoneBox.text = UserDefaults.standard.string(forKey: "phoneBilling")
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
