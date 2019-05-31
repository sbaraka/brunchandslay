//
//  ShopViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 4/2/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ShopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var shopTable: UITableView!
    
    
    var shopTableData: [ProductData] = []
    var jsonValues: JSON?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ShopDetailViewController
        {
            let vc = segue.destination as? ShopDetailViewController
            vc?.shopData = shopTableData[(shopTable.indexPathForSelectedRow?.row)!]
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = shopTable.dequeueReusableCell(withIdentifier: "merchandiseCell") as! ShopCell
        
        if(shopTableData[indexPath.row].name.count >= 24)
        {
            cell.nameLabel.text = shopTableData[indexPath.row].name.prefix(24) + "..."
        }
        else
        {
            cell.nameLabel.text = shopTableData[indexPath.row].name
        }
       
        
        let priceDouble = Double(shopTableData[indexPath.row].price)
        let formattedPrice = String(format: "%04.2f", priceDouble!)
        
        cell.priceLabel.text = "Price: $" + formattedPrice
    
        let imageURL = URL(string: shopTableData[indexPath.row].imageURLString)
        
        cell.previewImage.kf.setImage(with: imageURL)
        
        let backGroundView = UIView()
        
        backGroundView.backgroundColor = UIColor.init(displayP3Red: 255/255, green: 147/255, blue: 0/255, alpha: 255/255)
        
        cell.selectedBackgroundView = backGroundView
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //shopTableData = [
            //ShopData(name: "Test item 1", price: 10.00, description: "A cool item", preview: UIImage(named: "its_azizy_as_that")!),
            //ShopData(name: "Test item 2", price: 10.00, description: "A cool item", preview: UIImage(named: "sammys_secrets")!)
            
        //]
        
        let urlString = "https://brunchandslay.com/wp-json/wc/v2/products"
        
        let key = "ck_1f524b00ccc62c462dac098fee0a21c6ed852712"
        
        let pass = "cs_1b0196f008f336d3a4a7870e5e858abe3d208734"
        
        let credential = URLCredential(user: key, password: pass, persistence: .forSession)
        
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: key, password: pass){
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        Alamofire.request(urlString, headers: headers).authenticate(usingCredential: credential).responseJSON{ response in debugPrint(response)
            
            if let json = response.result.value
            {
                print("JSON: \(json)")
                self.jsonValues = JSON(json)
                
                for i in 0...((self.jsonValues?.array?.count)! - 1 )
                {
                    let id = self.jsonValues?[i]["id"].int
                    let name = self.jsonValues?[i]["name"].string
                    let description = self.jsonValues![i]["description"].string
                    let price = self.jsonValues![i]["price"].string
                    let imageURLString = self.jsonValues![i]["images"][0]["src"].string
                    
                    self.shopTableData.append(ProductData(id: id!, name: name!, description: description!, price: price!, imageURLString: imageURLString!))
                }
                
                DispatchQueue.main.async {
                    self.shopTable.reloadData()
                }
                
            }
            
        }
        
        
        
    }
    
    
}

