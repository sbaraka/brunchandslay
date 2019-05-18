//
//  RSSPodcastReader.swift
//  Brunch and Slay
//
//  Created by Noah on 5/15/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class RSSPodcastReader: NSObject, XMLParserDelegate
{
    private var podcastDataList: [PodcastData] = [PodcastData]()
    private var podcastDataElement: PodcastData = PodcastData(title: "", imageURLString: "", audioURLString: "", author: "")
    private var foundCharacters: String = ""
    
    var isParserDone: Bool = false
    
    
    func fetchPodcastsDataFromURL(url: URL) -> [PodcastData]
    {
        isParserDone = false
        podcastDataList = [PodcastData]()
        let task = URLSession.shared.dataTask(with: url) { data, response, error in guard let data = data, error == nil else {
                print (error ?? "Unknown error")
                return
            }
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        
        task.resume()
        
        while(!isParserDone)
        {
            
        }
        
        
        return podcastDataList
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if ( elementName == "enclosure" )
        {
            if var url = attributeDict["url"]
            {
                url.insert("s", at: url.index(url.startIndex, offsetBy: 4))
                self.podcastDataElement.audioURLString = url
            }
            
        }
        else if(elementName == "itunes:image")
        {
            if let imageURLString = attributeDict["href"]
            {
                //imageURLString.insert("s", at: imageURLString.index(imageURLString.startIndex, offsetBy: 4))
                self.podcastDataElement.imageURLString = imageURLString
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "title"
        {
            self.podcastDataElement.title = self.foundCharacters
        }
        else if elementName == "itunes:author"
        {
            self.podcastDataElement.author = self.foundCharacters
        }
        else if elementName == "item"
        {
            let tempPodcastData = PodcastData(title: podcastDataElement.title, imageURLString: podcastDataElement.imageURLString, audioURLString: podcastDataElement.audioURLString, author: podcastDataElement.author)
            self.podcastDataList.append(tempPodcastData)
        }
        self.foundCharacters = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundCharacters += string
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        isParserDone = true
    }
}
