//
//  ClassCell.swift
//  Brunch and Slay
//
//  Created by Noah on 4/18/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit

class ClassCell: UITableViewCell {

    @IBOutlet weak var classImage: UIImageView!
    
    
    @IBOutlet weak var classTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
