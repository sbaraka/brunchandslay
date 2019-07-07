//
//  VideoCell.swift
//  Brunch and Slay
//
//  Created by Noah on 7/5/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {

    @IBOutlet weak var videoThumbnailView: UIImageView!
    
    @IBOutlet weak var videoTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
