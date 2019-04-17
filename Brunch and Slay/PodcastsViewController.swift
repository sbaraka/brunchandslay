//
//  PodcastsViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 3/31/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit

class PodcastsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var podcastsTableData: [PodcastData] = []
    
    @IBOutlet weak var currentTitle: UILabel!
    
    @IBOutlet weak var playSlider: UISlider!
    
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var podcastsTable: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is PodcastDetailViewController
        {
            let vc = segue.destination as? PodcastDetailViewController
            vc?.podcastData = podcastsTableData[(podcastsTable.indexPathForSelectedRow?.row)!]
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcastsTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = podcastsTable.dequeueReusableCell(withIdentifier: "podcastCell") as! PodcastCell
        
        cell.titleLabel.text = podcastsTableData[indexPath.row].title
        
        let backGroundView = UIView()
        
        backGroundView.backgroundColor = UIColor.init(displayP3Red: 255/255, green: 147/255, blue: 0/255, alpha: 255/255)
        
        cell.selectedBackgroundView = backGroundView
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

