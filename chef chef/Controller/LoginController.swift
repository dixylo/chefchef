//
//  LoginController.swift
//  chef chef
//
//  Created by Jonathan on 5/05/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit

import Firebase
import TextFieldEffects
import SwiftyButton


extension UITextField {
    func setPadding(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setBottomBorder(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}


class LoginController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var loginbutton: PressableButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.setPadding()
        emailTextField.setBottomBorder()
        
        passwordTextField.setBottomBorder()
        passwordTextField.setPadding()
        
        
        
        loginbutton.colors = .init(
            button: .init(red: 176/255, green: 66/255, blue: 244/255, alpha: 1),
            shadow: .purple)
        loginbutton.shadowHeight = 2
        loginbutton.cornerRadius = 2
        

        
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
