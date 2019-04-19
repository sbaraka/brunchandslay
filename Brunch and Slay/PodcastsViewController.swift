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
    
    var podcastsTableData: [PodcastData] = []
    
    var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    
    var playerIsPlaying:Bool = false
    
    var playerTime: TimeInterval = 0.0
    
    @IBOutlet weak var currentTitle: UILabel!
    
    @IBOutlet weak var playSlider: UISlider!
    
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var podcastsTable: UITableView!
    
    @IBAction func previousAction(_ sender: Any) {
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
            
            
            if((podcastsTable.indexPathsForSelectedRows?.count)! > 0)
            {
                let asset = NSDataAsset(name: podcastsTableData[(podcastsTable.indexPathForSelectedRow?.row)!].audioURL)
                do
                {
                    audioPlayer = try AVAudioPlayer(data: asset!.data, fileTypeHint:"wav ")
                    
                    currentTitle.text = podcastsTableData[(podcastsTable.indexPathForSelectedRow?.row)!].title
                    
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                    playerIsPlaying = true
                    playButton.setImage(UIImage(named: "pause"), for: .normal)
                }
                catch let error as NSError
                {
                    print(error.localizedDescription)
                }
            }
            
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
    
        if((podcastsTable.indexPathsForSelectedRows?.count)! > 0)
            {
        
        
                if segue.destination is PodcastDetailViewController
                {
                    let vc = segue.destination as? PodcastDetailViewController
                    vc?.podcastData = podcastsTableData[(podcastsTable.indexPathForSelectedRow?.row)!]
                    vc?.audioPlayer = audioPlayer
                    vc?.playerIsPlaying = playerIsPlaying
                    vc?.playerTime = playerTime
            
                }
            }
    }
    
    
    @IBAction func nextAction(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcastsTableData.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = podcastsTable.dequeueReusableCell(withIdentifier: "podcastCell") as! PodcastCell
        
        cell.titleLabel.text = podcastsTableData[indexPath.row].title
        
        cell.album.image = podcastsTableData[indexPath.row].image
        
        
        let backGroundView = UIView()
        
        backGroundView.backgroundColor = UIColor.init(displayP3Red: 255/255, green: 147/255, blue: 0/255, alpha: 255/255)
        
        cell.selectedBackgroundView = backGroundView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        playButton.setImage(UIImage(named: "pause"), for: .normal)
        
        let asset = NSDataAsset(name: podcastsTableData[(indexPath.row)].audioURL)
        do
        {
            audioPlayer = try AVAudioPlayer(data: asset!.data, fileTypeHint:"wav ")
                
            currentTitle.text = podcastsTableData[(indexPath.row)].title
                
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            playerIsPlaying = true
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        currentTitle.text = "None Selected"
        
        podcastsTableData = [
            PodcastData(title: "Baking Pies with Noah",  image: UIImage(named: "baking_with_noah")!, audioURL: "bakingpies" ),
            PodcastData(title: "It's Aziz-y as That", image: UIImage(named:"its_azizy_as_that")!, audioURL: "bakingpies"),
            PodcastData(title: "Sammy's Secrets to Success", image: UIImage(named: "sammys_secrets")!, audioURL: "bakingpies"),
            PodcastData(title: "Shivam's Shopping Tips", image: UIImage(named: "shop_with_shivam")!, audioURL: "bakingpies")
            
        ]
        
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

