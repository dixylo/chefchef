//
//  PostViewController.swift
//  chef chef
//
//  Created by Jonathan on 12/06/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: UIViewController {
    
    @IBOutlet weak var txtTitle: UILabel!
    
    @IBOutlet weak var imgDisplay: UIImageView!
    
    @IBOutlet weak var txtContent: UITextView!
    
    var post: Post = Post()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitle.text = post.title
        txtContent.text = post.content
        
        //load the image
        let url = post.image
        
        let imageStorageRef = Storage.storage().reference(forURL:url)
        
        imageStorageRef.getData(maxSize: 3 * 1024 * 1024) { (data, error) in
            if error != nil{
                print("here is an error: \(error)")
            }else{
                //success
                if let imageData = data {
                    let image = UIImage(data:imageData)
                    self.imgDisplay.image = image
                }
            }
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
