//
//  CartCell.swift
//  Brunch and Slay
//
//  Created by Noah on 4/17/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {

    @IBOutlet weak var previewImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var taxLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
