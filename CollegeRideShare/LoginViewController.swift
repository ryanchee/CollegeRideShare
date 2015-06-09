//
//  ProfileViewController.swift
//  CollegeRideShare
//
//  Created by Ryan Chee on 5/17/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import UIKit

class LoginviewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func customFacebookLogin(sender: AnyObject) {
        var permissions = ["public_profile", "email", "user_friends"]
//        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(<#launchOptions: [NSObject : AnyObject]?#>)
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions) { [unowned self]
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                    self.returnUserData()
                    self.performSegueWithIdentifier("LoggedIn", sender: self)
                    
                } else {
                    println("User logged in through Facebook!")
                    println("photo username is: \(PFUser.currentUser()!.username!)")
                    self.returnUserData()
                    self.performSegueWithIdentifier("LoggedIn", sender: self)

                }
            }
            else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        }

    }
    @IBAction func loginPressed(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(loginTextField.text as String, password: passwordTextField.text as String) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                println("\(self.loginTextField.text)")
                self.performSegueWithIdentifier("LoggedIn", sender: self)
            }
            else {
                // The login failed. Check error to see why.
                if (self.loginTextField.text.isEmpty) {
                    
                    let alert = UIAlertView()
                    alert.title = "Missing Fields"
                    alert.message = "One or more of the fields are blank."
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                }
                else {
                    let alert = UIAlertView()
                    alert.title = "Login Error"
                    alert.message = "Username or Password is Incorrect"
                    alert.addButtonWithTitle("Ok")
                    alert.show()
                }
                
                println("nan")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        if (FBSDKAccessToken.currentAccessToken() != nil) {
//            println("already logged in")
//            self.performSegueWithIdentifier("LoggedIn", sender: self)
////            println("why not in next controller?")
////            // User is already logged in, do work such as go to next view controller.
//        }
//        else {
//            let loginView : FBSDKLoginButton = FBSDKLoginButton()
//            self.view.addSubview(loginView)
//            loginView.center = self.view.center
//            loginView.readPermissions = ["public_profile", "email", "user_friends"]
//            loginView.delegate = self
//        }
        // Do any additional setup after loading the view.
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ [unowned self] (connection, result, error) ->  Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println("fetched user: \(result)")
                let userName : String = result.valueForKey("name") as! String
                println("User Name is: \(userName)")
                let userEmail : String = result.valueForKey("email") as! String
                println("User Email is: \(userEmail)")
                let id: String = result.valueForKey("id") as! String
                var photoURL:String = "https://graph.facebook.com/\(id)/picture?type=large"
                println("here is the url: \(photoURL) ")
                var NSPhotoURL: NSURL = NSURL(string: photoURL)!
                let urlRequest = NSURLRequest(URL: NSPhotoURL)
                var data = NSData(contentsOfURL: NSPhotoURL)
                let image = UIImage(data: data!)
//                println("\(image)")
                var query = PFUser.query()
                println("photo username is: \(PFUser.currentUser()!.username!)")
                query!.whereKey("username", equalTo: PFUser.currentUser()!.username!)
                var user = query!.getFirstObject() as! PFUser
                user["Image"] = PFFile(name: "profileImage.jpg", data: UIImageJPEGRepresentation(image, 1.0))
                user.saveInBackground()
            }
        })
    }
    
    
    

    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        returnUserData()
        if ((error) != nil)
        {
            println("there was an error with facebook login")
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
            self.performSegueWithIdentifier("LoggedIn", sender: self)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("segue identifier = \(segue.identifier)")
        if segue.identifier == "LoggedIn" {
            let dest = segue.destinationViewController as! UITabBarController
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
