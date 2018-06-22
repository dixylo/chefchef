//
//  RecipeListController.swift
//  chef chef
//
//  Created by Jonathan on 5/05/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage


class RecipeListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var postsArray: [Post] = [Post]()
    var imageURL: String = ""
    @IBOutlet weak var recipeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Set myself as the delegate and datasource
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        //MARK: Register CustomPostCell.xib
        recipeTableView.register(UINib(nibName: "CustomPostCell", bundle: nil), forCellReuseIdentifier: "customPostCell")
        retrievePosts()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: declare cellForRowAtIndexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customPostCell", for: indexPath) as! CustomPostCell
        
        cell.cellAuthor.text = postsArray[indexPath.row].author
        cell.cellTitle.text = postsArray[indexPath.row].title
        cell.cellDescription.text = postsArray[indexPath.row].desciption
        let url = postsArray[indexPath.row].image
        
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
    
    

    
    //MARK: declare numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toPost", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PostViewController {
            destination.post = postsArray[(recipeTableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    func configureTableView()
    {
//        recipeTableView.rowHeight = UITableViewAutomaticDimension
        recipeTableView.estimatedRowHeight = 120.0
        recipeTableView.rowHeight = 180.0
        
    }
    

    //MARK: - retrieve data from firebase
    func retrievePosts() {
        guard (Auth.auth().currentUser?.uid) != nil else { return }
        let postDB = Database.database().reference().child("Messages")
        
        postDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>

            let post = Post()
            post.title = snapshotValue["Title"]!
            post.sender = snapshotValue["Sender"]!
            post.desciption = snapshotValue["Description"]!
            post.author = snapshotValue["Author"]!
            post.image = snapshotValue["Image"]!
            post.content = snapshotValue["Content"]!
            
            self.postsArray.append(post)
            self.configureTableView()
            self.recipeTableView.reloadData()
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
