//
//  ShippingViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 6/14/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit
import BraintreeCore
import BraintreePayPal
import BraintreeDropIn
import Alamofire
import SwiftyJSON

class ShippingViewController: UIViewController {
    
    let tokenKey = "sandbox_v28y3428_77cbcs58byh4ys4f"
    
    var brainTreeClient: BTAPIClient?
    
    @IBOutlet weak var firstNameBox: UITextField!
    
    @IBOutlet weak var lastNameBox: UITextField!
    
    @IBOutlet weak var companyBox: UITextField!
    
    @IBOutlet weak var countryButton: UIButton!
    
    @IBOutlet weak var address1Box: UITextField!
    
    @IBOutlet weak var address2Box: UITextField!
    
    @IBOutlet weak var cityBox: UITextField!
    
    @IBOutlet weak var stateButton: UIButton!
    
    @IBOutlet weak var zipBox: UITextField!
    
    
    @IBAction func openPayPal(_ sender: Any) {
        //Start filling shipping data
        ShoppingCart.instance.order?.shipping.firstName = firstNameBox.text!
        
        ShoppingCart.instance.order?.shipping.lastName = lastNameBox.text!
        
        ShoppingCart.instance.order?.shipping.companyName = companyBox.text!
        
        ShoppingCart.instance.order?.shipping.country = (countryButton.titleLabel?.text)!
        
        ShoppingCart.instance.order?.shipping.address1 = address1Box.text!
        
        ShoppingCart.instance.order?.shipping.address2 = address2Box.text!
        
        ShoppingCart.instance.order?.shipping.city = cityBox.text!
        
        ShoppingCart.instance.order?.shipping.state = (stateButton.titleLabel?.text)!
        
        ShoppingCart.instance.order?.shipping.postalCode = zipBox.text!
        //End of filling shipping data
        
        showDropIn(clientTokenOrTokenizationKey: tokenKey)
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
