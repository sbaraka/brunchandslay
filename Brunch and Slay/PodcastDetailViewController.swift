//
//  PodcastDetailViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 4/16/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import AVFoundation
import UIKit

class PodcastDetailViewController: UIViewController, UINavigationControllerDelegate{
    
    var timer: Timer!
    
    var audioURLString: String = ""
    
    var podcastsTableData:[PodcastData]?
    
    var podcastData:PodcastData?
    
    var playerIsPlaying:Bool?
    
    var audioPlayer:AVPlayer?
    
    var rowIndex:Int?
    
    var practicalParent: PodcastsViewController?
    
    weak var delegate: PodcastsViewController!
    
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    
    @IBOutlet weak var album: UIImageView!
    
    @IBOutlet weak var playSlider: UISlider!
    
    
    @IBOutlet weak var previousButton: UIButton!
    
    
    @IBOutlet weak var playButton: UIButton!
    
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func previousAction(_ sender: Any) {
        if(rowIndex! > 0)
        {
            rowIndex = rowIndex! - 1
            
            let tempURLString = podcastsTableData![rowIndex!].audioURLString
            if(tempURLString != audioURLString)
            {
                audioURLString = tempURLString
                
                let asset = AVURLAsset(url: URL(string: audioURLString)!)
                
            asset.resourceLoader.setDelegate(ResourceLoadingDelegate(), queue: DispatchQueue.global(qos: .userInitiated))
                
                let playerItem = AVPlayerItem(asset: asset)
            
                if(audioPlayer == nil)
                {
                    audioPlayer = AVPlayer(playerItem: playerItem)
                }
                else
                {
                    audioPlayer?.replaceCurrentItem(with: playerItem)
                }
                
                
                
                playSlider.value = 0
                
                audioPlayer!.seek(to: CMTime.zero, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero) { (isFinished:Bool) in DispatchQueue.main.async {
                        do
                        {
                            try AVAudioSession.sharedInstance().setActive(true)
                        }
                        catch
                        {
                            print(error)
                        }
                        self.audioPlayer!.play()
                        self.playerIsPlaying = true
                        self.titleView.text = self.podcastsTableData![self.rowIndex!].title
                    
                        self.authorLabel.text = self.podcastsTableData![self.rowIndex!].author
                    
                        let imageURL = URL(string: self.podcastsTableData![self.rowIndex!].imageURLString)
                    
                        self.album.kf.setImage(with: imageURL)
                    }
                    
                }
                
            }
        }
    }
    
    
    @IBAction func playAction(_ sender: Any) {
        
        
        if(playerIsPlaying!)
        {
            playButton.setImage(UIImage(named: "play"), for: .normal)
            
            audioPlayer!.pause()
            do
            {
                try AVAudioSession.sharedInstance().setActive(false)
            }
            catch
            {
                print(error)
            }
            playerIsPlaying = false
            
            //titleView.text = "None Selected"
        }
        else
        {
            let url = podcastData!.audioURLString
            let asset = AVURLAsset(url: URL(string: url)!)
            let playerItem = AVPlayerItem(asset: asset)
            
            audioPlayer = AVPlayer(playerItem: playerItem)
                
            titleView.text = podcastsTableData![rowIndex!].title
            let seconds = audioPlayer?.currentItem!.asset.duration.seconds
            
            let doubleTime = Double(seconds! * Double(playSlider.value))
            let cmTime = CMTime(seconds: doubleTime, preferredTimescale: (audioPlayer?.currentItem?.asset.duration.timescale)!)
            audioPlayer!.seek(to: cmTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero) { (isFinished:Bool) in
                DispatchQueue.main.async {
                    do
                    {
                        try AVAudioSession.sharedInstance().setActive(true)
                    }
                    catch
                    {
                        print(error)
                    }
                    self.audioPlayer!.play()
                    self.playerIsPlaying = true
                    self.playButton.setImage(UIImage(named: "pause"), for: .normal)
                }
            }
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        
        if(rowIndex! < (podcastsTableData?.count)! - 1)
        {
            rowIndex = rowIndex! + 1
            
            let tempURLString = podcastsTableData![rowIndex!].audioURLString
            if(tempURLString != audioURLString)
            {
                audioURLString = tempURLString
                
                let asset = AVURLAsset(url: URL(string: audioURLString)!)
                
                asset.resourceLoader.setDelegate(ResourceLoadingDelegate(), queue: DispatchQueue.global(qos: .userInitiated))
                
                let playerItem = AVPlayerItem(asset: asset)
                
                if(audioPlayer == nil)
                {
                    audioPlayer = AVPlayer(playerItem: playerItem)
                }
                else
                {
                    audioPlayer?.replaceCurrentItem(with: playerItem)
                }
                
                    
                playSlider.value = 0
                
                audioPlayer!.seek(to: CMTime.zero, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero) { (isFinished:Bool) in DispatchQueue.main.async {
                        do
                        {
                            try AVAudioSession.sharedInstance().setActive(true)
                        }
                        catch
                        {
                            print(error)
                        }
                        self.audioPlayer!.play()
                        self.playerIsPlaying = true
                        self.titleView.text = self.podcastsTableData![self.rowIndex!].title
                        
                        self.authorLabel.text = self.podcastsTableData![self.rowIndex!].author
                        
                        let imageURL = URL(string: self.podcastsTableData![self.rowIndex!].imageURLString)
                        
                        self.album.kf.setImage(with: imageURL)
                    }
                    
                }
                
            }
        }
        
    }
    @IBAction func startScrub(_ sender: Any) {
        if(playerIsPlaying!)
        {
            audioPlayer!.pause()
            do
            {
                try AVAudioSession.sharedInstance().setActive(false)
            }
            catch
            {
                print(error)
            }
        }
    }
    
    @IBAction func scrubAudio(_ sender: Any) {
       
        if(playerIsPlaying!)
        {
            let seconds = audioPlayer!.currentItem!.asset.duration.seconds
            let doubleTime = Double(seconds * Double(playSlider.value))
            let cmTime = CMTime(seconds: doubleTime, preferredTimescale: ((audioPlayer?.currentItem?.asset.duration.timescale)!))
            audioPlayer!.seek(to: cmTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero) { (isFinished:Bool) in
                do
                {
                    try AVAudioSession.sharedInstance().setActive(true)
                }
                catch
                {
                    print(error)
                }
                self.audioPlayer!.play()
            }
        }
        else
        {
           let seconds = audioPlayer!.currentItem!.asset.duration.seconds
            let doubleTime = Double(seconds * Double(playSlider.value))
            let cmTime = CMTime(seconds: doubleTime, preferredTimescale: ((audioPlayer?.currentItem?.asset.duration.timescale)!))
            audioPlayer!.seek(to: cmTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        }
        
    }
    
    @objc func updateSlider() {
        if(playerIsPlaying! && audioPlayer?.rate != 0)
        {
            playSlider.value = Float(audioPlayer!.currentTime().seconds/audioPlayer!.currentItem!.asset.duration.seconds)
            
            let total = Int(audioPlayer!.currentTime().seconds)
            
            let minutes = Int(audioPlayer!.currentTime().seconds/60)
            
            let seconds = total - 60 * minutes
            
            currentTimeLabel.text = String(minutes) + ":" + String(format: "%02d", seconds)
            
            let endTotal = Int(audioPlayer!.currentItem!.asset.duration.seconds)
            
            let endMinutes = Int(endTotal / 60)
            
            let endSeconds = Int(endTotal - 60 * endMinutes)
            
            endTimeLabel.text = String(endMinutes) + ":" + String(format: "%02d",endSeconds)
        }
    }
    
    @objc func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        playButton.setImage(UIImage(named: "play"), for: .normal)
        
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let indexPath = IndexPath(row: rowIndex!, section: 0)
        if viewController is TabController
        {
            practicalParent?.podcastsTable.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
            practicalParent?.tableView((practicalParent?.podcastsTable)!, didSelectRowAt: indexPath)
            practicalParent?.playSlider.value = playSlider.value
            practicalParent?.audioPlayer = audioPlayer!
            practicalParent?.playerIsPlaying = playerIsPlaying!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.delegate = self
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
        
        
        titleView.text = podcastData?.title
        authorLabel.text = podcastData?.author
        
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
