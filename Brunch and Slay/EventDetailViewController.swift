//
//  EventDetailViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 4/15/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {

    var eventData:EventData?
    
    @IBOutlet weak var eventImage: UIImageView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = eventData?.name
        dateLabel.text = eventData?.date
        locationLabel.text = eventData?.location
        descriptionLabel.text = eventData?.description
        eventImage.image = eventData?.image
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
