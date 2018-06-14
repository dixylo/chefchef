//
//  RegisterController.swift
//  chef chef
//
//  Created by Jonathan on 5/05/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit
import Firebase

class RegisterController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var ageTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error)
            }else {
                print("Register Successfuly! ")
                self.performSegue(withIdentifier: "toMain", sender: self)
            }
        }
        // save users info into the firebase database
        let postDB = Database.database().reference().child("Users")
        let postDictionary = ["Email":emailTextField.text,
                              "Password": passwordTextField.text]
        postDB.childByAutoId().setValue(postDictionary) { (error, reference) in
            if error != nil {
                print(error)
            }else{
                print(reference)
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
