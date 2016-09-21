//
//  ProfileViewController.swift
//  AirBnB Clone
//
//  Created by orlando arzola on 15.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        profileImageView.image = UIImage(named: "user.jpg")
        
    
        // Checking if for User info
        if (FBSDKAccessToken.current() != nil) {
            
            fetchInfo()
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchInfo () {
        
        
        // Requesting User Information from Facebook
        
        let parameters = ["fields" : "email, first_name, last_name, picture.type(large)"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            if error != nil {
                
                print(error)
            } else {
                
                if let result = result as? NSDictionary {
                    
                    if let email = result["email"] as? String {
                        
                        print(email)
                    }
                    
                    if let firstName = result["first_name"] as? String {
                        
                        if let lastName = result["last_name"] as? String {
                            
                            self.nameLabel.text = firstName + " " + lastName
                        }
                        
                        
                    }
                    
                    
                    // Getting the image from facebook user
                    
                    if let picture = result["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"] as? String {
                        
                        print(url)
                        
                        let url = URL(string: url)!
                        
                        let request = NSMutableURLRequest(url: url)
                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                            data, response, error in
                            
                            if error != nil {
                                
                                print(error)
                            } else {
                                
                                if let data = data {
                                    
                                    if let image = UIImage(data: data) {
                                        
                                        
                                        DispatchQueue.main.async() { () -> Void in
                                            
                                            self.profileImageView.image = image
                                        }
                                        

                                    }
                                }
                            }
                            
                        }
                        
                        task.resume()
                    }
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        // Circular ImageView
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
        profileImageView.clipsToBounds = true
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
