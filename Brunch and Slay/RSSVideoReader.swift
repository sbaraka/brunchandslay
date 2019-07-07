//
//  RSSVideoReader.swift
//  Brunch and Slay
//
//  Created by Noah on 7/5/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import Foundation

class RSSVideoReader: NSObject, XMLParserDelegate
{
    private var videoDataList: [VideoData] = [VideoData]()
    private var videoDataElement = VideoData(videoURLString: "", thumbnailURLString: "", title: "")
    private var tempElementData = ""
    private var isParserDone = false
    private var tryAgain = false
    
    func fetchVideoDataFromURL(url: URL) ->[VideoData]
    {
        isParserDone = false
        videoDataList = [VideoData]()
        var task = URLSession.shared.dataTask(with: url)
        {
            data, response, error in guard
                let data = data, error == nil
                else {
                        print(error ?? "Unknown error")
                        self.tryAgain = true
                        return
                }
            self.tryAgain = false
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        
        task.resume()
        
        while(!isParserDone)
        {
            if(tryAgain)
            {
                task.cancel()
                tryAgain = false
                task = URLSession.shared.dataTask(with: url)
                {
                    data, response, error in guard
                        let data = data, error == nil
                        else {
                            print(error ?? "Unknown error")
                            self.tryAgain = true
                            return
                    }
                    self.tryAgain = false
                    let parser = XMLParser(data: data)
                    parser.delegate = self
                    parser.parse()
                }
                
                task.resume()
            }
        }
        
        return videoDataList
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
       /* if(elementName == "link")
        {
            if let videoURLString = attributeDict["href"]
            {
            self.videoDataElement.videoURLString = videoURLString
            }
            
        }
        else*/
        if(elementName == "media:thumbnail")
        {
            if let thumbnailURLString = attributeDict["url"]
            {
                self.videoDataElement.thumbnailURLString = thumbnailURLString
            }
        }
        
        self.tempElementData = ""
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "yt:videoId"
        {
            self.videoDataElement.videoURLString = "https://www.youtube.com/embed/" + self.tempElementData
        }
        if elementName == "media:title"
        {
            self.videoDataElement.title = self.tempElementData
        }
        else if elementName == "entry"
        {
            let tempVideoData = VideoData(videoURLString: videoDataElement.videoURLString, thumbnailURLString: videoDataElement.thumbnailURLString, title: videoDataElement.title)
        self.videoDataList.append(tempVideoData)
        }
        
        self.tempElementData = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.tempElementData = self.tempElementData + string
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        isParserDone = true
    }
    
    
}
