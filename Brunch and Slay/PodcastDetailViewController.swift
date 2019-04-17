//
//  PodcastDetailViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 4/16/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit

class PodcastDetailViewController: UIViewController {
    
    var podcastData:PodcastData?
    
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var album: UIImageView!
    
    @IBOutlet weak var playSlider: UISlider!
    
    
    @IBOutlet weak var previousButton: UIButton!
    
    
    @IBOutlet weak var playButton: UIButton!
    
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleView.text = podcastData?.title
        album.image = podcastData?.image
        
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
