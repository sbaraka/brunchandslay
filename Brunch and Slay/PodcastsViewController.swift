//
//  PodcastsViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 3/31/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import AVFoundation
import UIKit

class PodcastsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var rssPodcastReader: RSSPodcastReader = RSSPodcastReader()
    var timer: Timer!
    
    var podcastsTableData: [PodcastData] = []
    
    var audioPlayer: AVPlayer!
    var playerIsPlaying:Bool = false
    
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
        if(podcastsTable.indexPathForSelectedRow!.row > 0)
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
                let doubleTime = Double(playSlider.value)
                let cmTime = CMTime(seconds: doubleTime, preferredTimescale: 1000000)
                audioPlayer.seek(to: cmTime)
                audioPlayer.play()
                playerIsPlaying = true
                playButton.setImage(UIImage(named: "pause"), for: .normal)
               
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
        if(podcastsTable.indexPathForSelectedRow!.row < podcastsTableData.count - 1)
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
        
            let doubleTime = Double(playSlider.value)
            let cmTime = CMTime(seconds: doubleTime, preferredTimescale: 1000000)
            audioPlayer.seek(to: cmTime)
            audioPlayer.play()
        }
        else
        {
            let doubleTime = Double(playSlider.value)
            let cmTime = CMTime(seconds: doubleTime, preferredTimescale: 1000000)
            audioPlayer.seek(to: cmTime)
        }
    }
    
    
    
    @objc func updateSlider() {
        if(playerIsPlaying && audioPlayer.rate != 0)
        {
            playSlider.value = Float(CMTimeGetSeconds(audioPlayer.currentTime()))
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcastsTableData.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = podcastsTable.dequeueReusableCell(withIdentifier: "podcastCell") as! PodcastCell
        
        cell.titleLabel.text = podcastsTableData[indexPath.row].title
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
        let cell = tableView.cellForRow(at: indexPath) as! PodcastCell
        
        let url = podcastsTableData[(podcastsTable.indexPathForSelectedRow?.row)!].audioURLString
        let asset = AVAsset(url: URL(string: url)!)
        
        let playerItem = AVPlayerItem(asset: asset)
        
        playButton.setImage(UIImage(named: "pause"), for: .normal)
            
        audioPlayer = AVPlayer(playerItem: playerItem)
        
        currentTitle.text = cell.titleLabel.text
            
        playSlider.maximumValue = Float(CMTimeGetSeconds(playerItem.duration))
            
        audioPlayer.play()
        playerIsPlaying = true
        
        
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

