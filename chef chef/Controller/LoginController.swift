//
//  LoginController.swift
//  chef chef
//
//  Created by Jonathan on 5/05/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit

import Firebase


class LoginController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var loginbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error)
            }else {
                print("Login Successfully! ")
                self.performSegue(withIdentifier: "loginToMain", sender: self)
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
