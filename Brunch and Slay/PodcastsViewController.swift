//
//  PodcastsViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 3/31/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import AVFoundation
import UIKit
import Kingfisher

class PodcastsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var rssPodcastReader: RSSPodcastReader = RSSPodcastReader()
    var timer: Timer!
    
    var podcastsTableData: [PodcastData] = []
    
    var audioURLString: String = ""
    
    var audioPlayer: AVPlayer!
    
    var playerIsPlaying:Bool = false
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var currentTitle: UILabel!
    
    @IBOutlet weak var playSlider: UISlider!
    
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var podcastsTable: UITableView!
    
    @IBAction func detailButtonPressed(_ sender: Any) {
        
        if(podcastsTable.indexPathForSelectedRow != nil)
        {
            performSegue(withIdentifier: "showPodcastDetail", sender: sender)
        }
    }
    
    
    @IBAction func previousAction(_ sender: Any) {
        if(podcastsTable.indexPathForSelectedRow != nil && podcastsTable.indexPathForSelectedRow!.row > 0)
        {
            let indexPath = IndexPath(row: podcastsTable.indexPathForSelectedRow!.row - 1, section: 0 )
            podcastsTable.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
            self.tableView(self.podcastsTable, didSelectRowAt: indexPath)
        }
    }
    
    
    @IBAction func playAction(_ sender: Any) {
        
        
        if(playerIsPlaying)
        {
            playButton.setImage(UIImage(named: "play"), for: .normal)
            
            audioPlayer.pause()
            playerIsPlaying = false;
            
            currentTitle.text = "None Selected"
        }
        else
        {
            
            let path:IndexPath? = podcastsTable!.indexPathForSelectedRow
            if(path != nil)
            {
                let url = podcastsTableData[(podcastsTable.indexPathForSelectedRow?.row)!].audioURLString
                let asset = AVAsset(url: URL(string: url)!)
                
                let playerItem = AVPlayerItem(asset: asset)
                
                audioPlayer = AVPlayer(playerItem: playerItem )
                    
                currentTitle.text = podcastsTableData[(podcastsTable.indexPathForSelectedRow?.row)!].title
                let seconds = audioPlayer.currentItem!.asset.duration.seconds
                
                let doubleTime = Double( seconds * Double(playSlider.value))
                let cmTime = CMTimeMakeWithSeconds( doubleTime, preferredTimescale: (audioPlayer.currentItem?.asset.duration.timescale)!)
                audioPlayer.seek(to: cmTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero) { (isFinished:Bool) in
                    self.audioPlayer.play()
                    self.playerIsPlaying = true
                    self.playButton.setImage(UIImage(named: "pause"), for: .normal)
                }
               
            }
            
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
    
        if(podcastsTable.indexPathForSelectedRow != nil)
        {
        
        
            if segue.destination is PodcastDetailViewController
            {
                let vc = segue.destination as? PodcastDetailViewController
                vc?.delegate = self
                vc?.podcastData = podcastsTableData[(podcastsTable.indexPathForSelectedRow?.row)!]
                vc?.audioPlayer = audioPlayer
                vc?.playerIsPlaying = playerIsPlaying
                vc?.podcastsTableData = podcastsTableData
                vc?.rowIndex = (podcastsTable.indexPathForSelectedRow?.row)!
            }
        }
    }
    
    
    @IBAction func nextAction(_ sender: Any) {
        if(podcastsTable.indexPathForSelectedRow != nil && podcastsTable.indexPathForSelectedRow!.row < podcastsTableData.count - 1)
        {
            let indexPath = IndexPath(row: podcastsTable.indexPathForSelectedRow!.row + 1, section: 0 )
            podcastsTable.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
            self.tableView(self.podcastsTable, didSelectRowAt: indexPath)
        }
        
    }
    
    @IBAction func startScrub(_ sender: Any) {
        if(playerIsPlaying)
        {
            audioPlayer.pause()
        }
    }
    
    @IBAction func scrubAudio(_ sender: Any) {
        
        if(playerIsPlaying)
        {
            let seconds = audioPlayer.currentItem!.asset.duration.seconds
            let doubleTime = Double(seconds * Double(playSlider.value))
            let cmTime = CMTimeMakeWithSeconds(doubleTime, preferredTimescale: (audioPlayer.currentItem?.asset.duration.timescale)!)
            audioPlayer.seek(to: cmTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero) { (isFinished:Bool) in
                self.audioPlayer.play()
            }
            
        }
        else
        {
            if(audioPlayer.currentItem != nil)
            {
                let seconds = audioPlayer.currentItem!.asset.duration.seconds
                let doubleTime = Double(seconds * Double(playSlider.value))
                let cmTime = CMTimeMakeWithSeconds(doubleTime, preferredTimescale: audioPlayer.currentItem!.asset.duration.timescale)
                audioPlayer.seek(to: cmTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
            }
        }
    }
    
    
    
    @objc func updateSlider() {
        if(playerIsPlaying && audioPlayer.rate != 0)
        {
            playSlider.value = Float(audioPlayer.currentTime().seconds/(audioPlayer.currentItem?.asset.duration.seconds)!)
            let total = Int(audioPlayer.currentTime().seconds)
            
            let minutes = Int(audioPlayer.currentTime().seconds/60)
            
            let seconds = total - 60 * minutes
            
            currentTimeLabel.text = String(minutes) + ":" + String(seconds)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcastsTableData.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = podcastsTable.dequeueReusableCell(withIdentifier: "podcastCell") as! PodcastCell
        
        if(podcastsTableData[indexPath.row].title.count >= 34)
        {
            cell.titleLabel.text = podcastsTableData[indexPath.row].title.prefix(34) + "..."
        }
        else
        {
            cell.titleLabel.text = podcastsTableData[indexPath.row].title
        }
        
        cell.authorLabel.text = podcastsTableData[indexPath.row].author
        
        let url = URL(string: podcastsTableData[indexPath.row].imageURLString)
        
        cell.album.kf.setImage(with: url)
        
        let backGroundView = UIView()
        
        backGroundView.backgroundColor = UIColor.init(displayP3Red: 255/255, green: 147/255, blue: 0/255, alpha: 255/255)
        
        cell.selectedBackgroundView = backGroundView
        
        return cell
    }
    
    @objc func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        playButton.setImage(UIImage(named: "play"), for: .normal)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        if let cell = tableView.cellForRow(at: indexPath) as! PodcastCell?
        {
            let tempURLString = podcastsTableData[(podcastsTable.indexPathForSelectedRow?.row)!].audioURLString
            if(tempURLString != audioURLString)
            {
                audioURLString = tempURLString
            
                if(playerIsPlaying)
                {
                    audioPlayer.pause()
                }
        
                let asset = AVURLAsset(url: URL(string: audioURLString)!)
        
                asset.resourceLoader.setDelegate(ResourceLoadingDelegate(), queue: DispatchQueue.global(qos: .userInitiated))
            
                let playerItem = AVPlayerItem(asset: asset)
            
                if(audioPlayer == nil)
                {
                    audioPlayer = AVPlayer(playerItem: playerItem)
                }
                else
                {
                    audioPlayer.replaceCurrentItem(with: playerItem)
                }
            
        
                //while(!(playerItem.status == AVPlayerItem.Status.readyToPlay || playerItem.status == AVPlayerItem.Status.failed) ){}
        
                if(playerItem.status == AVPlayerItem.Status.readyToPlay)
                {
                    currentTitle.text = cell.titleLabel.text
                    //playSlider.maximumValue = Float(playerItem.asset.duration.seconds)
                    let total = Int(playerItem.asset.duration.seconds)
                    
                    let minutes = Int(total / 60)
                    
                    let seconds = Int(total - 60 * minutes)
                    
                    endTimeLabel.text = String(minutes) + ":" + String(seconds)
                    
                    
                    playButton.setImage(UIImage(named: "pause"), for: .normal)
                    //audioPlayer.seek(to: CMTimeMakeWithSeconds(0.0, preferredTimescale: 1000000))
                    audioPlayer.play()
                    playerIsPlaying = true
            
                }
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
        
        currentTitle.text = "None Selected"
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        let url = URL(string: "https://feeds.soundcloud.com/users/soundcloud:users:323536510/sounds.rss")
        
        podcastsTableData = rssPodcastReader.fetchPodcastsDataFromURL(url: url!)

        
        if(playerIsPlaying)
        {
            playButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        else
        {
            playButton.setImage(UIImage(named: "play"), for: .normal)
        }
    }


}

