//
//  PodcastsViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 3/31/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import AVFoundation
import UIKit

class PodcastsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate {
    
    var timer: Timer!
    
    var podcastsTableData: [PodcastData] = []
    
    var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    
    var playerIsPlaying:Bool = false
    
    @IBOutlet weak var currentTitle: UILabel!
    
    @IBOutlet weak var playSlider: UISlider!
    
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var podcastsTable: UITableView!
    
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
                let asset = NSDataAsset(name: podcastsTableData[(podcastsTable.indexPathForSelectedRow?.row)!].audioURL)
                do
                {
                    audioPlayer = try AVAudioPlayer(data: asset!.data, fileTypeHint:"wav")
                    audioPlayer.delegate = self
                    
                    currentTitle.text = podcastsTableData[(podcastsTable.indexPathForSelectedRow?.row)!].title
                    
                    
                    audioPlayer.prepareToPlay()
                    audioPlayer.currentTime = TimeInterval(playSlider.value)
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
        
            audioPlayer.prepareToPlay()
            audioPlayer.currentTime = TimeInterval(playSlider.value)
            audioPlayer.play()
        }
        else
        {
            audioPlayer.currentTime = TimeInterval(playSlider.value)
        }
    }
    
    
    
    @objc func updateSlider() {
        if(playerIsPlaying && audioPlayer.isPlaying)
        {
            playSlider.value = Float(audioPlayer.currentTime)
        }
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
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        playButton.setImage(UIImage(named: "play"), for: .normal)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath) as! PodcastCell
        
        let asset = NSDataAsset(name: podcastsTableData[(indexPath.row)].audioURL)
        do
        {
            playButton.setImage(UIImage(named: "pause"), for: .normal)
            
            audioPlayer = try AVAudioPlayer(data: asset!.data, fileTypeHint:"wav")
                
            currentTitle.text = podcastsTableData[(podcastsTable.indexPathForSelectedRow?.row)!].title
            currentTitle.text = cell.titleLabel.text
            
            playSlider.maximumValue = Float(audioPlayer.duration)
            
            audioPlayer.delegate = self
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
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
        
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

