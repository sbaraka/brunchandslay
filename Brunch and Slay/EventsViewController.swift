//
//  EventsViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 3/31/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var eventsTable: UITableView!
    
    var eventsTableData: [EventData] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is EventDetailViewController
        {
            let vc = segue.destination as? EventDetailViewController
            vc?.eventData = eventsTableData[(eventsTable.indexPathForSelectedRow?.row)!]
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventsTable.dequeueReusableCell(withIdentifier: "protoCell") as! EventTableCell
        cell.nameLabel.text = eventsTableData[indexPath.row].name
        
        cell.locationLabel.text = eventsTableData[indexPath.row].location
        
        cell.dateLabel.text = eventsTableData[indexPath.row].date
        
        let backGroundView = UIView()
        
        backGroundView.backgroundColor = UIColor.init(displayP3Red: 255/255, green: 147/255, blue: 0/255, alpha: 255/255)
        
        cell.selectedBackgroundView = backGroundView
        
        return cell
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        eventsTableData = [
            EventData(name: "Test 1", location: "Here", date: "Today", description: "This is just a test with a bunch of garbage text. The quick brown fox jumps over the lazy dog"),
            EventData(name: "Test 2", location: "Here", date: "Today", description: "This is just a test with a bunch of garbage text. The quick brown fox jumps over the lazy dog")
        ]
        
    }


}

