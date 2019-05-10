//
//  PodcastDetailViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 4/16/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import AVFoundation
import UIKit

class PodcastDetailViewController: UIViewController, AVAudioPlayerDelegate {
    
    var timer: Timer!
    
    var podcastsTableData:[PodcastData]?
    
    var podcastData:PodcastData?
    
    var playerIsPlaying:Bool?
    
    var audioPlayer:AVAudioPlayer?
    
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
            let asset = NSDataAsset(name: podcastsTableData![rowIndex!].audioURL)
            do
            {
                audioPlayer = try AVAudioPlayer(data: asset!.data, fileTypeHint:"wav")
                
                titleView.text = podcastsTableData![rowIndex!].title
                
                album.image = podcastsTableData![rowIndex!].image
                
                playSlider.maximumValue = Float((audioPlayer?.duration)!)
                
                audioPlayer?.delegate = self
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
                playerIsPlaying = true
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
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
            
            let asset = NSDataAsset(name: podcastData!.audioURL)
            do
            {
                audioPlayer = try AVAudioPlayer(data: asset!.data, fileTypeHint:"wav ")
                audioPlayer!.delegate = self
                
                titleView.text = podcastsTableData![rowIndex!].title
                
            
                    
                audioPlayer!.prepareToPlay()
                audioPlayer!.currentTime = TimeInterval(playSlider.value)
                audioPlayer!.play()
                playerIsPlaying = true
                playButton.setImage(UIImage(named: "pause"), for: .normal)
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
            
            
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        
        if(rowIndex! < (podcastsTableData?.count)! - 1)
        {
            rowIndex = rowIndex! + 1
            let asset = NSDataAsset(name: podcastsTableData![rowIndex!].audioURL)
            do
            {
                audioPlayer = try AVAudioPlayer(data: asset!.data, fileTypeHint:"wav")
                
                titleView.text = podcastsTableData![rowIndex!].title
                
                album.image = podcastsTableData![rowIndex!].image
                
                playSlider.maximumValue = Float((audioPlayer?.duration)!)
                
                audioPlayer?.delegate = self
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
                playerIsPlaying = true
            }
            catch let error as NSError
            {
                print(error.localizedDescription)
            }
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
            audioPlayer!.prepareToPlay()
            audioPlayer!.currentTime = TimeInterval(playSlider.value)
            audioPlayer!.play()
        }
        else
        {
            audioPlayer!.currentTime = TimeInterval(playSlider.value)
        }
        
    }
    
    @objc func updateSlider() {
        if(playerIsPlaying! && (audioPlayer?.isPlaying)!)
        {
            playSlider.value = Float(audioPlayer!.currentTime)
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
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        playButton.setImage(UIImage(named: "play"), for: .normal)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
        
        
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
