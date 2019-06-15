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
