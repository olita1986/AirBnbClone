//
//  LoginViewController.swift
//  AirBnB Clone
//
//  Created by orlando arzola on 15.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let loginButton = FBSDKLoginButton()
        
        loginButton.readPermissions = ["email"]
        loginButton.center = view.center
        
        loginButton.delegate = self
        
        view.addSubview(loginButton)
        
       // performSegue(withIdentifier: "showPlaces", sender: self)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.tabBarController?.tabBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //FBSDKLogin delegate
    
     func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
       _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    /*!
     @abstract Sent to the delegate when the button was used to logout.
     @param loginButton The button that was clicked.
     */
     func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        
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
