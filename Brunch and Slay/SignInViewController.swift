//
//  SignInViewController.swift
//  Brunch and Slay
//
//  Created by Noah on 4/2/19.
//  Copyright © 2019 Brunch and Slay. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailBox: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: Actions
    
    @IBAction func enterClicked(_ sender: Any) {
        
        //use email and password to authorize user and pull data
        let emailString = emailBox.text
        let passString = passwordTextField.text
    }
    
    @IBAction func switchChanged(_ sender: Any) {
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    
    @IBAction func createAccountClicked(_ sender: Any) {
        //create to save user data
        performSegue(withIdentifier: "goToCreateUser", sender: sender)
    }
}
