//
//  CheckOutViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 6/10/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit
import BraintreeCore
import BraintreePayPal
import BraintreeDropIn

class CheckOutViewController: UIViewController {

    
    let tokenKey = "sandbox_v28y3428_77cbcs58byh4ys4f"
    
    var brainTreeClient: BTAPIClient?
    
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
