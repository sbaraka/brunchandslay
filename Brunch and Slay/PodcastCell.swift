//
//  PodcastCell.swift
//  Brunch and Slay
//
//  Created by Noah on 4/17/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit

class PodcastCell: UITableViewCell {

    
    @IBOutlet weak var album: UIImageView!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
