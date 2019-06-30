//
//  CreateUserViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 6/30/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class CreateUserViewController: UIViewController {
    
    @IBOutlet weak var firstNameBox: UITextField!
    
    @IBOutlet weak var lastNameBox: UITextField!
    
    @IBOutlet weak var usernameBox: UITextField!
    
    @IBOutlet weak var emailBox: UITextField!
    
    @IBOutlet weak var passwordBox: UITextField!
    
    @IBOutlet weak var confirmPasswordBox: UITextField!
    
    @IBAction func submitClicked(_ sender: Any) {
        
        let usersURLString = "https://brunchandslay.com/wp-json/wp/v2/users"
        
        let key = "ck_1f524b00ccc62c462dac098fee0a21c6ed852712"
        
        let pass = "cs_1b0196f008f336d3a4a7870e5e858abe3d208734"
        
        let credential = URLCredential(user: key, password: pass, persistence: .forSession)
        
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: key, password: pass){
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        
        let firstName = firstNameBox.text
        let lastName = lastNameBox.text
        let username = usernameBox.text
        let email = emailBox.text
        let password = passwordBox.text
        let confirmPassword = confirmPasswordBox.text
        
        //check for password match
        let passwordMatch = password == confirmPassword
        
        Alamofire.request(usersURLString, headers: headers).authenticate(usingCredential: credential).responseJSON{ response in debugPrint(response)
            
            if let json = response.result.value
            {
                let usersJSON = JSON(json)
                
                //check for taken email
                var availableEmail = true
                
                for i in 0...(usersJSON.array?.count)! - 1
                {
                    if(usersJSON[i]["email"].stringValue == email)
                    {
                        availableEmail = false
                        break
                    }
                }
                
                //check for taken username
                var availableUsername = true
                
                for i in 0...(usersJSON.array?.count)! - 1
                {
                    if(usersJSON[i]["username"].stringValue == username)
                    {
                        availableUsername = false
                        break
                    }
                }
                
                let safeToSubmit = passwordMatch && availableEmail && availableUsername
                
                if(safeToSubmit)
                {
                    
                }
                else
                {
                    
                }
                
            }
        }
    
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
