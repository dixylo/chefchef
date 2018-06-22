//
//  createViewController.swift
//  chef chef
//
//  Created by Jonathan on 15/05/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import Alamofire
import AlamofireImage
import Toucan



class createViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var authorTextField: UITextField!
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet var sendButton: UIButton!
    
    
    @IBOutlet weak var contentTextView: UITextView!
    
    
    @IBOutlet weak var progressView: UIProgressView!
    
    var imageData: NSData = NSData()
    var imagePostUrl: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(createViewController.tapDetected))
        imageView.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK send button pressed
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
 
        
        firebasePost()
    }
    
    
    @IBAction func uploadPicPressed(_ sender: UIButton) {
        uploadImageToFirebaseStrorage(data: imageData)
    }
    
    func firebasePost(){
        titleTextField.endEditing(true)
        titleTextField.isEnabled = false
        
        descriptionTextField.endEditing(true)
        descriptionTextField.isEnabled = false
        
        authorTextField.endEditing(true)
        authorTextField.isEnabled = false
        
        sendButton.isEnabled = false
        
        let postDB = Database.database().reference().child("Messages")
        let postDictionary = ["Sender": Auth.auth().currentUser?.email,
                              "Title":titleTextField.text!,
                              "Description":descriptionTextField.text!,
                              "Author":authorTextField.text!,
                              "Content": contentTextView.text!,
                              "Image":imagePostUrl]
        
        
        postDB.childByAutoId().setValue(postDictionary){
            (error,reference) in
            
            if error != nil {
                print(error)
            }else {
                print("Message saved successfully")
                
                self.titleTextField.isEnabled = true
                self.descriptionTextField.isEnabled = true
                self.authorTextField.isEnabled = true
                self.sendButton.isEnabled = true
                self.titleTextField.text = ""
                self.descriptionTextField.text = ""
                self.authorTextField.text = ""
                self.contentTextView.text = ""
                
                
            }
            
        }
    }
    
    func uploadImageToFirebaseStrorage(data: NSData) {
        sendButton.isEnabled = false
        let storageRef = Storage.storage().reference(withPath: "Images/\(Date().timeIntervalSince1970).jpg")
        let uploadMetadate = StorageMetadata()
        uploadMetadate.contentType = "image/jpeg"
        let uploadTask = storageRef.putData(data as Data, metadata: uploadMetadate) { (metadata,error) in
            if error != nil{
                print("I received an error \(error?.localizedDescription)")
            }else{
                print("Upload complete! Here's some metadata! \(metadata)")
                print("Here's your download URL: \(metadata?.downloadURL())")
                self.imagePostUrl = metadata!.downloadURL()!.relativeString
                
                self.imageResponse()
            }
        }
        uploadTask.observe(.progress) { (snapshot) in
            guard let progress = snapshot.progress else {
                return
            }
            self.progressView.progress = Float(progress.fractionCompleted)
        }
    }
    
    func imageResponse(){
        Alamofire.request(imagePostUrl).responseImage { (response) in
            debugPrint(response)
            print(response.request)
            print(response.response)
            debugPrint(response.result)
            if let image = response.result.value{
                print("image downloaded: \(image)")
                self.sendButton.isEnabled = true
            }
        }
    }
    
    func imageSelect(){
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller,animated: true,completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let resizedImage = Toucan(image: image).resize(CGSize(width: 207, height: 164), fitMode: Toucan.Resize.FitMode.crop).image
        
        imageView.image = resizedImage
        imageData = UIImagePNGRepresentation(resizedImage!)! as NSData
        
        dismiss(animated: true, completion: nil)
    }
    @objc func tapDetected(){
        print("hello")
        imageSelect()
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
