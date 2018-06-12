//
//  FavoriteController.swift
//  chef chef
//
//  Created by Jonathan on 5/05/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//
import Firebase
import UIKit

class FavoriteController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let fireDB = Database.database().reference()
    var postsArray: [Post] = [Post]()
    var userKey = ""
    var postKey = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .blue
        refreshControl.addTarget(self, action: #selector(refreshPostArray), for: .valueChanged)
        
        
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = refresher

        // Do any additional setup after loading the view.
        //queryGet()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomFavoriteCell", bundle: nil), forCellReuseIdentifier: "favoriteCell")
        
        
        
        retrieveFavoriteForUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    
    
    
    func queryGet() {
        let userRef = Database.database().reference().child("Messages")
        let queryRef = userRef.queryOrdered(byChild: "Sender").queryEqual(toValue: "test@test.com")
        
        queryRef.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children {
                let userSnap = snap as! DataSnapshot
                let uid = userSnap.key
                print("key:\(uid)")
            }
        }
        
    
    }
    
    
    
    //MARK: - declare cellForRowAtIndexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! CustomFavoriteCell
        
        cell.cellTitle.text = postsArray[indexPath.row].title
        
        let url = postsArray[indexPath.row].image
        print("here is the url: \(url)")
        let imageStorageRef = Storage.storage().reference(forURL:url)
        
        
        imageStorageRef.getData(maxSize: 3 * 1024 * 1024) { (data, error) in
            if error != nil{
                print("here is an error: \(error)")
            }else{
                //success
                if let imageData = data {
                    let image = UIImage(data:imageData)
                    cell.cellImage.image = image
                }
            }
        }
        
        
        return cell
    }
    
    //MARK: - declare numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return postsArray.count
        return postsArray.count
    }
    
    //TODO: - Retrieve the list of favorite posts for particular user
    
    func retrieveFavoriteForUser(){
        
        
        let userRef = fireDB.child("Users").queryOrdered(byChild: "Email").queryEqual(toValue: Auth.auth().currentUser?.email)
        
        
        // MARK: - retrieve user key from user table
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children {
                let userSnap = snap as! DataSnapshot
                self.userKey = userSnap.key
                print("userKey \(self.userKey)")
                self.getPostIdFromFavorite()
                self.configureTableView()
                self.tableView.reloadData()
            }
        }
        
        // TODO: - going to favorite table, get all the post by using user key
        
    }
    //MARK:- refresh the table and async data from database
    @objc func refreshPostArray(){
        postsArray.removeAll()
        getPostIdFromFavorite()
        let deadline = DispatchTime.now() + .milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
        tableView.reloadData()
        
    }
    
    func getPostIdFromFavorite(){
        let favoriteRef = fireDB.child("Favorites").child("\(userKey)")
        
        favoriteRef.observe(.childAdded) { (snapshot) in
            let snap = snapshot as! DataSnapshot
            let snapValue = snapshot.value as! Dictionary<String,Bool>
            print("post: \(snap.key)")
            self.postKey = snap.key
            
            if snapValue["Favorited"] == true {
                self.getPosts()
                
            }
            
        }
        

    }
    
    
    
    func getPosts() {
        let messageRef = fireDB.child("Messages").child("\(postKey)")
        messageRef.observeSingleEvent(of: .value) { (snapshot) in
            
            let postshot = snapshot.value as! Dictionary<String,String>
            
            let post = Post()
            post.title = postshot["Title"]!
            post.sender = postshot["Sender"]!
            post.desciption = postshot["Description"]!
            post.author = postshot["Author"]!
            post.image = postshot["Image"]!
            
            
            self.postsArray.append(post)
            self.configureTableView()
            self.tableView.reloadData()
            print("number of array:\(self.postsArray.count)")
            
            
        }
        
    }
    
    //Remove post from local list
    func removePostsFromLocal() {
//        let messageRef = fireDB.child("Messages").child("\(postKey)")
//        messageRef.observeSingleEvent(of: .value) { (snapshot) in
//            let postshot = snapshot.value as! Dictionary<String,String>
//
//            let post = Post()
//            post.title = postshot["Title"]!
//            post.sender = postshot["Sender"]!
//            post.desciption = postshot["Description"]!
//            post.author = postshot["Author"]!
//            post.image = postshot["Image"]!
//
//
//
//        }
//        postsArray.removeat
        configureTableView()
        tableView.reloadData()
        
    }
    
    func configureTableView()
    {
        //        recipeTableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0
        tableView.rowHeight = 140.0
        
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
