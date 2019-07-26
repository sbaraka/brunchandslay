//
//  VideoListViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 4/2/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit
import WebKit


class VideoListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var rssVideoReader = RSSVideoReader()
    
    var videoTableData: [VideoData] = []
    
    @IBOutlet weak var videoTable: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return videoTableData.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = videoTable.dequeueReusableCell(withIdentifier: "videoCell") as! VideoCell
       
        let thumbnailURL = URL(string: videoTableData[indexPath.row].thumbnailURLString)
        cell.videoThumbnailView.kf.setImage(with: thumbnailURL)
        
        cell.videoTitleLabel.text = videoTableData[indexPath.row].title
        
        let backGroundView = UIView()
        
        backGroundView.backgroundColor = UIColor.init(displayP3Red: 4/255, green: 6/255, blue: 54/255, alpha: 220/255)
        
        cell.selectedBackgroundView = backGroundView
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(videoTable.indexPathForSelectedRow != nil)
        {
            if(segue.destination is VideoPlayerViewController)
            {
                let vc = segue.destination as? VideoPlayerViewController
                vc?.videoData = videoTableData[videoTable.indexPathForSelectedRow!.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView.cellForRow(at: indexPath) as! VideoCell? != nil
        {
            performSegue(withIdentifier: "openVideo", sender: tableView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoTable.delegate = self
        videoTable.dataSource = self
        
        let url = URL(string: "https://www.youtube.com/feeds/videos.xml?channel_id=UC1q_zY04Ry-HWmiBpFikjkQ")
    DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            }
        
            self.videoTableData = self.rssVideoReader.fetchVideoDataFromURL(url: url!)
            
            DispatchQueue.main.async {
                self.videoTable.reloadData()
            self.activityIndicator.stopAnimating()
            }
        }
    }

}
