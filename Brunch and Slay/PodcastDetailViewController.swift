//
//  PodcastDetailViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 4/16/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import AVFoundation
import UIKit

class PodcastDetailViewController: UIViewController {
    
    var podcastData:PodcastData?
    
    var playerTime:TimeInterval?
    
    var playerIsPlaying:Bool?
    
    var audioPlayer:AVAudioPlayer?
    
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var album: UIImageView!
    
    @IBOutlet weak var playSlider: UISlider!
    
    
    @IBOutlet weak var previousButton: UIButton!
    
    
    @IBOutlet weak var playButton: UIButton!
    
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func previousAction(_ sender: Any) {
    }
    
    
    @IBAction func playAction(_ sender: Any) {
        if(playerIsPlaying!)
        {
            playButton.setImage(UIImage(named: "play"), for: .normal)
            
            audioPlayer!.pause()
        }
        else
        {
            playButton.setImage(UIImage(named: "pause"), for: .normal)
            
            let asset = NSDataAsset(name: podcastData!.audioURL)
            do
            {
                audioPlayer = try AVAudioPlayer(data: asset!.data, fileTypeHint:"wav ")
                    
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
                playerIsPlaying = true
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
            
            
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleView.text = podcastData?.title
        album.image = podcastData?.image
        
        if(playerIsPlaying!)
        {
            playButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        else
        {
            playButton.setImage(UIImage(named: "play"), for: .normal)
        }
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
