//
//  ShopViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 4/2/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var shopTable: UITableView!
    
    var shopTableData: [ShopData] = []
    
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
        
        cell.nameLabel.text = shopTableData[indexPath.row].name
        
        cell.priceLabel.text = "Price: " + String(format:"%.2f",shopTableData[indexPath.row].price)
    
        
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
