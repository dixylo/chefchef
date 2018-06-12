//
//  CustomPostCell.swift
//  chef chef
//
//  Created by Jonathan on 15/05/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit
import Firebase





class CustomPostCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var cellTitle: UILabel!
    
    @IBOutlet weak var cellDescription: UILabel!
    
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    
    @IBOutlet weak var cellAuthor: UILabel!
    
    var postID = ""
    var userID = ""
    var post: Post = Post()
    let fireDB = Database.database().reference()
    
    override func prepareForReuse() {
        cellTitle.text = "Title"
        cellAuthor.text = "Author"
        cellDescription.text = "Description"
        cellImage.image = UIImage(named: "food")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let currentUser = Auth.auth().currentUser?.email
        let userRef = Database.database().reference().child("Users")
        let queryRef = userRef.queryOrdered(byChild: "Email").queryEqual(toValue: currentUser)
        // get userID
        queryRef.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children {
                let userSnap = snap as! DataSnapshot
                let uid = userSnap.key
                self.userID = uid
                print("key:\(self.userID)")
                
                
                //get postID
                let postRef = Database.database().reference().child("Messages")
                let postQueryRef = postRef.queryOrdered(byChild: "Title").queryEqual(toValue: self.cellTitle.text)
                
                postQueryRef.observeSingleEvent(of: .value) { (snapshot) in
                    for snap in snapshot.children {
                        let userSnap = snap as! DataSnapshot
                        let uid = userSnap.key
                        self.postID = uid
                        print("key:\(self.postID)")
                        
                        //favorite
                        let favoriteRef = self.fireDB.child("Favorites").child("\(self.userID)").child("\(self.postID)")
                        favoriteRef.observe(.childAdded) { (snapshot) in
                            let snap = snapshot as! DataSnapshot
                            
                            
                            let favorited = snap.value as! Bool
                            print("post: \(favorited)")
                            if favorited == true {
                                self.favoriteSwitch.isOn = true
                                print("1")
                            }else{
                                self.favoriteSwitch.isOn = false
                                print("2")
                            }
                            
                        }
                        
                    }
                }
                
            }
        }
        
        
        
        
        
        
        
        
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func favoriteSwitch(_ sender: UISwitch) {
        if sender.isOn {
            retrievePostAutoID()
            retrieveUserAutoID()
        }else{
            retrievePostAutoID()
            removeFromFavorite()
        }
    }
    
    
    func retrievePostAutoID() {
        let userRef = Database.database().reference().child("Messages")
        let queryRef = userRef.queryOrdered(byChild: "Title").queryEqual(toValue: cellTitle.text)
        
        queryRef.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children {
                let userSnap = snap as! DataSnapshot
                let uid = userSnap.key
                self.postID = uid
                print("key:\(self.postID)")
                
            }
        }
    }
    
    func retrieveUserAutoID(){
        let currentUser = Auth.auth().currentUser?.email
        let userRef = Database.database().reference().child("Users")
        let queryRef = userRef.queryOrdered(byChild: "Email").queryEqual(toValue: currentUser)
        
        queryRef.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children {
                let userSnap = snap as! DataSnapshot
                let uid = userSnap.key
                self.userID = uid
                print("key:\(self.userID)")
                
                self.addToFavorite()
            }
        }
    }
    
    //MARK: - remove from favorite
    func removeFromFavorite(){
        let currentUser = Auth.auth().currentUser?.email
        let userRef = Database.database().reference().child("Users")
        let queryRef = userRef.queryOrdered(byChild: "Email").queryEqual(toValue: currentUser)
        
        queryRef.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children {
                let userSnap = snap as! DataSnapshot
                let uid = userSnap.key
                self.userID = uid
                print("key:\(self.userID)")
                
                self.setValueToFalse()
            }
        }
    }
    
    //MARK: - Add post to favorite
    func addToFavorite() {
        let db = Database.database().reference().child("Favorites")
        let favoriteDb = db.child("\(userID)").child("\(postID)")
        let favDictionary = ["Favorited":true]
        print("123")
        
        
        
//        favoriteDb.childByAutoId().setValue(favDictionary) { (error, reference) in
//            if error != nil {
//                print(error)
//            }else {
//                print("Added Successfully")
//            }
//        }
        
        favoriteDb.setValue(favDictionary) { (error, reference) in
            if error != nil {
                print(error)
            }else {
                print("Added Successfully")
            }
        }
        
    }
    
    //MARK: - Set favorited value to false
    func setValueToFalse() {
        let db = Database.database().reference()
        let favoriteDb = db.child("Favorites").child("\(userID)").child("\(postID)")
        let favDictionary = ["Favorited":false]
        
        
        
        //        favoriteDb.childByAutoId().setValue(favDictionary) { (error, reference) in
        //            if error != nil {
        //                print(error)
        //            }else {
        //                print("Added Successfully")
        //            }
        //        }
        
        favoriteDb.setValue(favDictionary) { (error, reference) in
            if error != nil {
                print(error)
            }else {
                print("Added Successfully")
            }
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
