//
//  ConfirmPaymentViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 6/26/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit

class ConfirmPaymentViewController: UIViewController {

    
    @IBAction func goBackToRoot(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
