//
//  BillingViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 6/14/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit
import BraintreeCore
import BraintreePayPal
import BraintreeDropIn

class BillingViewController: UIViewController {
    
    let tokenKey = "sandbox_v28y3428_77cbcs58byh4ys4f"
    
    var brainTreeClient: BTAPIClient?
    
    var shippingSameAsBilling: Bool = false
    
    @IBOutlet weak var firstNameBox: UITextField!
    
    @IBOutlet weak var lastNameBox: UITextField!
    
    @IBOutlet weak var companyNameBox: UITextField!
    
    @IBOutlet weak var countryButton: UIButton!
    
    @IBOutlet weak var address1Box: UITextField!
    
    @IBOutlet weak var address2Box: UITextField!
    
    @IBOutlet weak var cityBox: UITextField!
    
    @IBOutlet weak var stateButton: UIButton!
    
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
        
        if(shippingSameAsBilling)
        {
          showDropIn(clientTokenOrTokenizationKey: tokenKey)
        }
        else
        {
            performSegue(withIdentifier: "goToShipping", sender: sender)
        }
        
    }
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request = BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        {
            (controller,result,error) in
            if (error != nil) {
                print("ERROR")
            }
            else if(result?.isCancelled == true){
                print("CANCELLED")
            }
            else if let result = result {
                
                let orderURLString = "https://brunchandslay.com/wp-json/wc/v2/orders"
                
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
                    
                    
                }
                
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        brainTreeClient = BTAPIClient(authorization: self.tokenKey)
        
        //Start filling in billing data
        ShoppingCart.instance.order?.billing.firstName = firstNameBox.text!
        
        ShoppingCart.instance.order?.billing.lastName = lastNameBox.text!
        
        ShoppingCart.instance.order?.billing.companyName = companyNameBox.text!
        
        ShoppingCart.instance.order?.billing.country = (countryButton.titleLabel?.text)!
        
        ShoppingCart.instance.order?.billing.address1 = address1Box.text!
        
        ShoppingCart.instance.order?.billing.address2 = address2Box.text!
        
        ShoppingCart.instance.order?.billing.city = cityBox.text!
        
        ShoppingCart.instance.order?.billing.state = (stateButton.titleLabel?.text)!
        
        ShoppingCart.instance.order?.billing.postalCode = zipBox.text!
        
        ShoppingCart.instance.order?.billing.email = emailBox.text!
        
        ShoppingCart.instance.order?.billing.phone = phoneBox.text!
        //End of filling billing data

        if(shippingSameAsBilling)
        {
            checkBoxButton.setImage(UIImage(named: "checkbox_checked")!, for: .normal)
            
            shippingOrPayPalButton.titleLabel?.text = "Proceed to PayPal"
            
            shippingOrPayPalButton.frame = CGRect(x: 121, y: 571, width: 133, height: 30)
            
            shippingOrPayPalButton.setBackgroundImage(UIImage(named: "PayPal_button_backgroud-1"), for: .normal)
            
            shippingOrPayPalButton.titleLabel?.textColor = UIColor.white
            
            
            //Start filling shipping data
            ShoppingCart.instance.order?.shipping.firstName = firstNameBox.text!
            
            ShoppingCart.instance.order?.shipping.lastName = lastNameBox.text!
            
            ShoppingCart.instance.order?.shipping.companyName = companyNameBox.text!
            
            ShoppingCart.instance.order?.shipping.country = (countryButton.titleLabel?.text)!
            
            ShoppingCart.instance.order?.shipping.address1 = address1Box.text!
            
            ShoppingCart.instance.order?.shipping.address2 = address2Box.text!
            
            ShoppingCart.instance.order?.shipping.city = cityBox.text!
            
            ShoppingCart.instance.order?.shipping.state = (stateButton.titleLabel?.text)!
            
            ShoppingCart.instance.order?.shipping.postalCode = zipBox.text!
            //End of filling shipping data
            
        }
        else
        {
            checkBoxButton.setImage(UIImage(named: "checkbox_unchecked")!, for: .normal)
            
            shippingOrPayPalButton.titleLabel?.text = "Continue"
            
            shippingOrPayPalButton.frame = CGRect(x: 154, y: 571, width: 67, height: 30)
            
            shippingOrPayPalButton.setBackgroundImage(UIImage(named: "picker_button_background-2"), for: .normal)
            
            shippingOrPayPalButton.titleLabel?.textColor = UIColor.white
        }
        
        // Do any additional setup after loading the view.
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
