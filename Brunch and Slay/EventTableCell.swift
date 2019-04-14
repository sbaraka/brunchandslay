//
//  EventTableCell.swift
//  Brunch and Slay
//
//  Created by Noah on 4/14/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit

class EventTableCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

