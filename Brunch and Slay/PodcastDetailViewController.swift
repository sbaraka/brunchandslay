//
//  PodcastDetailViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 4/16/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import AVFoundation
import UIKit

class PodcastDetailViewController: UIViewController{
    
    var timer: Timer!
    
    var podcastsTableData:[PodcastData]?
    
    var podcastData:PodcastData?
    
    var playerIsPlaying:Bool?
    
    var audioPlayer:AVPlayer?
    
    var rowIndex:Int?
    
    weak var delegate: PodcastsViewController!
    
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var album: UIImageView!
    
    @IBOutlet weak var playSlider: UISlider!
    
    
    @IBOutlet weak var previousButton: UIButton!
    
    
    @IBOutlet weak var playButton: UIButton!
    
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func previousAction(_ sender: Any) {
        if(rowIndex! > 0)
        {
            rowIndex = rowIndex! - 1
            
            let audioURLString = podcastsTableData![rowIndex!].audioURLString
            let asset = AVAsset(url: URL(string: audioURLString)!)
            let playerItem = AVPlayerItem(asset: asset)
            
            audioPlayer = AVPlayer(playerItem: playerItem)
                
            titleView.text = podcastsTableData![rowIndex!].title
            
            let imageURL = URL(string: podcastsTableData![rowIndex!].imageURLString)
            
            album.kf.setImage(with: imageURL)
                
            playSlider.maximumValue = Float(CMTimeGetSeconds(playerItem.duration))
                
            audioPlayer?.play()
            playerIsPlaying = true
        }
    }
    
    
    @IBAction func playAction(_ sender: Any) {
        
        
        if(playerIsPlaying!)
        {
            playButton.setImage(UIImage(named: "play"), for: .normal)
            
            audioPlayer!.pause()
            playerIsPlaying = false
            
            titleView.text = "None Selected"
        }
        else
        {
            let url = podcastData!.audioURLString
            let asset = AVAsset(url: URL(string: url)!)
            let playerItem = AVPlayerItem(asset: asset)
            
            audioPlayer = AVPlayer(playerItem: playerItem)
            
            
                
            titleView.text = podcastsTableData![rowIndex!].title
            let doubleTime = Double(playSlider.value)
            let cmTime = CMTime(seconds: doubleTime, preferredTimescale: 1000000)
            audioPlayer!.seek(to: cmTime)
            audioPlayer!.play()
            playerIsPlaying = true
            playButton.setImage(UIImage(named: "pause"), for: .normal)
            
            
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        
        if(rowIndex! < (podcastsTableData?.count)! - 1)
        {
            rowIndex = rowIndex! + 1
            
            let audioURLString = podcastsTableData![rowIndex!].audioURLString
            let asset = AVAsset(url: URL(string: audioURLString)!)
            let playerItem = AVPlayerItem(asset: asset)
            
            audioPlayer = AVPlayer(playerItem: playerItem)
                
            titleView.text = podcastsTableData![rowIndex!].title
            
            let imageURLString = podcastsTableData![rowIndex!].imageURLString
            let imageURL = URL(string: imageURLString)
            
            album.kf.setImage(with: imageURL)
                
            playSlider.maximumValue = Float(CMTimeGetSeconds(playerItem.duration))
            
            audioPlayer?.play()
            playerIsPlaying = true
        }
        
    }
    @IBAction func startScrub(_ sender: Any) {
        if(playerIsPlaying!)
        {
           audioPlayer!.pause()
        }
    }
    
    @IBAction func scrubAudio(_ sender: Any) {
       
        if(playerIsPlaying!)
        {
            let doubleTime = Double(playSlider.value)
            let cmTime = CMTime(seconds: doubleTime, preferredTimescale: 1000000)
            audioPlayer!.seek(to: cmTime)
            audioPlayer!.play()
        }
        else
        {
            let doubleTime = Double(playSlider.value)
            let cmTime = CMTime(seconds: doubleTime, preferredTimescale: 1000000)
            audioPlayer!.seek(to: cmTime)
        }
        
    }
    
    @objc func updateSlider() {
        if(playerIsPlaying! && audioPlayer?.rate != 0)
        {
            playSlider.value = Float(CMTimeGetSeconds(audioPlayer!.currentTime()))
        }
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if (parent != nil)
        {
            let indexPath = IndexPath(row: rowIndex!, section: 0)
            let castParent = parent as! PodcastsViewController
            castParent.audioPlayer = audioPlayer!
            castParent.currentTitle.text = titleView.text
            castParent.playerIsPlaying = playerIsPlaying!
            castParent.podcastsTable.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        }
    }
    
    @objc func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        playButton.setImage(UIImage(named: "play"), for: .normal)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
        
        
        titleView.text = podcastData?.title
        let imageURLString = podcastData?.imageURLString
        let imageURL = URL(string: imageURLString!)
        
        album.kf.setImage(with: imageURL)
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
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
