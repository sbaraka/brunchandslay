//
//  EventsViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 3/31/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var eventsTable: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var eventsTableData: [EventData] = []
    
    var postImageXMLParser = PostImageXMLParser()
    
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
    
    func buildEventFromJSON(json: JSON) -> EventData
    {
        var event = EventData(name: "", location: "", date: "", description: "", imageURLString: "")
        
        event.name = json["title"]["rendered"].stringValue
        
        let contentStringArray = json["content"]["rendered"].stringValue.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "").split(separator: "\n")
        
        var locationArray = contentStringArray[0].components(separatedBy: ": ")
        
        locationArray.removeFirst()
        
        event.location = locationArray.joined(separator: ": ")
        
        var dateArray = contentStringArray[1].components(separatedBy: ": ")
        
        dateArray.removeFirst()
        
        event.date = dateArray.joined(separator: ": ")
        
        var descriptArray = contentStringArray[2].components(separatedBy: ": ")
        
        descriptArray.removeFirst()
        
        event.description = descriptArray.joined(separator: ": ")
        
        event.imageURLString = postImageXMLParser.getImageURLStringFromTag(tag: String(contentStringArray[3]))
        return event
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let eventsURLString = "https://brunchandslay.com/wp-json/wp/v2/posts"
        
        Alamofire.request(eventsURLString).responseJSON{
            
            response in debugPrint(response)
            
            if let json = response.result.value
            {
                DispatchQueue.main.async {
                    self.activityIndicator.startAnimating()
                }
                
                let jsonValues = JSON(json)
                
                for i in 0...((jsonValues.array?.count)! - 1 )
                {
                    var isEvent = false
                    
                    for j in 0...((jsonValues[i]["tags"].array?.count)! - 1)
                    {
                        if(jsonValues[i]["tags"][j].intValue == 189)
                        {
                            isEvent = true
                        }
                    }
                    
                    if(isEvent)
                    {
                        self.eventsTableData.append(self.buildEventFromJSON(json: jsonValues[i]))
                    }
                }
                
                DispatchQueue.main.async {
                    self.eventsTable.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }
            
        }
        
    }
    
    
}

