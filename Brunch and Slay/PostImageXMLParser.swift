//
//  PostImageXMLParser.swift
//  Brunch and Slay
//
//  Created by Noah on 7/15/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import Foundation

class PostImageXMLParser: NSObject, XMLParserDelegate
{
    private var imageURLString = ""
    
    private var tempElementData = ""

    func getImageURLStringFromTag(tag: String) -> String
    {
        let cleanXML = tag.replacingOccurrences(of: "\\\"", with: "\"")

        let parser = XMLParser(data: cleanXML.data(using: .utf8)!)
        parser.delegate = self
        parser.parse()
        
        return imageURLString
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if(elementName == "img")
        {
            if let urlString = attributeDict["src"]
            {
                self.imageURLString = urlString.replacingOccurrences(of: "http://", with: "https://")
            }
            
        }
        
        self.tempElementData = ""
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        self.tempElementData = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.tempElementData = self.tempElementData + string
    }
}
