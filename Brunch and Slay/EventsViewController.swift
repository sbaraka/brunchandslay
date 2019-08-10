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
        
        cell.locationLabel.text = "Location: " + eventsTableData[indexPath.row].location
        
        cell.dateLabel.text = "Date: " + eventsTableData[indexPath.row].date
        
        let backGroundView = UIView()
        
        backGroundView.backgroundColor = UIColor.init(displayP3Red: 4/255, green: 6/255, blue: 54/255, alpha: 220/255)
        
        cell.selectedBackgroundView = backGroundView
        
        return cell
    }
    
    func buildEventFromJSON(json: JSON) -> EventData
    {
        var event = EventData(name: "", location: "", date: "", description: "", imageURLString: "")
        
        event.name = json["title"]["rendered"].stringValue
        
        let rawContentStringArray = json["content"]["rendered"].stringValue.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "").split(separator: "\n")
        
        let encodedContent = json["content"]["rendered"].stringValue
        
        guard let data = encodedContent.data(using: .utf8) else
        {
             return event
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else
        {
            return event
        }
        
        let contentStringArray = attributedString.string.split(separator: "\n")
        
        var locationArray = contentStringArray[0].components(separatedBy: ": ")
        
        locationArray.removeFirst()
        
        event.location = locationArray.joined(separator: ": ")
        
        var dateArray = contentStringArray[1].components(separatedBy: ": ")
        
        dateArray.removeFirst()
        
        event.date = dateArray.joined(separator: ": ")
        
        var descriptArray = contentStringArray[2].components(separatedBy: ": ")
        
        descriptArray.removeFirst()
        
        event.description = descriptArray.joined(separator: ": ")
        
        event.imageURLString = postImageXMLParser.getImageURLStringFromTag(tag: String(rawContentStringArray[3]))
        return event
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let eventsURLString = "https://brunchandslay.com/wp-json/wp/v2/posts"
        
        self.view.bringSubviewToFront(activityIndicator)
        
        Alamofire.request(eventsURLString).responseJSON{
            
            response in debugPrint(response)
            
            if let json = response.result.value
            {
                DispatchQueue.main.async {
                    self.activityIndicator.startAnimating()
                }
                
                let jsonValues = JSON(json)
                
                let iCount = (jsonValues.array?.count) ?? 0
                if (iCount > 0)
                {
                    for i in 0...(iCount - 1 )
                    {
                        var isEvent = false
                        
                        let jCount = (jsonValues[i]["tags"].array?.count) ?? 0
                        
                        if(jCount > 0)
                        {
                            for j in 0...(jCount - 1)
                            {
                                if(jsonValues[i]["tags"][j].intValue == 190)
                                {
                                    isEvent = true
                                }
                            }
                        }
                        
                        if(isEvent)
                        {
                            DispatchQueue.main.async {
                                self.eventsTableData.append(self.buildEventFromJSON(json: jsonValues[i]))
                            }
                        }
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

