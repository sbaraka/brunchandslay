//
//  ClassesViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 4/2/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit
import WebKit

class YoutubeCell:UITableViewCell{
    @IBOutlet weak var youtubewebview: WKWebView!
}




class ClassesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    let list = [URL(string:"https://www.youtube.com/embed/WR4QQsNm1ok"), URL(string:"https://www.youtube.com/embed/N1cHWRi7Nrg"),URL(string:"https://www.youtube.com/embed/-KpZxW_BIbc"),URL(string:"https://www.youtube.com/embed/GbB1OkRQoQw"),URL(string:"https://www.youtube.com/embed/jBnmHE9y3so"),URL(string:"https://www.youtube.com/embed/D7MSgjhBze8"),URL(string:"https://www.youtube.com/embed/crdphdQzsuE"),URL(string:"https://www.youtube.com/embed/HCHvrtwYejQ"),URL(string:"https://www.youtube.com/embed/RtEWJ31ff5s")]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return list.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
//        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "youtubecell")
//        cell.textLabel?.text = list[indexPath.row]
//        return cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "youtubecell") as! YoutubeCell
        let url = URL(string:"https://www.youtube.com/embed/WR4QQsNm1ok")
        cell.youtubewebview.load(URLRequest(url: list[indexPath.row]!))
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //getVideo(videoCode: "WR4QQsNm1ok")
    }
//    func getVideo(videoCode:String){
//        let url = URL(string:"https://www.youtube.com/embed/\(videoCode)")
//        youtubewebview.load(URLRequest(url: url!))
//    }
}
