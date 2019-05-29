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
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var quantityBox: UITextField!
    
    @IBOutlet weak var quantityStepper: UIStepper!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //previewImage.image = shopData?.preview
        nameLabel.text = shopData?.name
        priceLabel.text = "Price: " + String(format:"%.2f", (shopData?.price)!)
        //descriptionLabel.text = shopData?.description
        
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
