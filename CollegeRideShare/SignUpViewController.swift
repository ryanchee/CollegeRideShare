//
//  SignUpViewController.swift
//  CollegeRideShare
//
//  Created by Ryan Chee on 5/17/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBAction func signupPressed(sender: AnyObject) {
        var user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        user.email = emailField.text
        // other fields can be set just like with PFObject
        
        user.signUpInBackgroundWithBlock {
            (succeeded, error) -> Void in
            if error == nil {
                // Hooray! Let them use the app now.
                let alert = UIAlertView()
                alert.title = "Registration Successful!"
                alert.message = "You are now logged in."
                alert.addButtonWithTitle("Ok")
                alert.show()
                self.performSegueWithIdentifier("SignedUp", sender: self)
            } else {
                let alert = UIAlertView()
                alert.title = "Missing Fields"
                alert.message = "One or more of the fields are blank."
                alert.addButtonWithTitle("Ok")
                alert.show()
                // Show the errorString somewhere and let the user try again.
            }
            
        }
    }
    @IBAction func fbPressed(sender: AnyObject) {
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookButton = FBSDKLoginButton()
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        self.view.addSubview(loginView)
        loginView.center = self.view.center
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        loginView.delegate = self
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func registerUser()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                println("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                println("User Email is: \(userEmail)")

                var user = PFUser()
                user.username = userName as String
                user.password = ""
                user.email = userEmail as String
                // other fields can be set just like with PFObject
                
                user.signUpInBackgroundWithBlock {
                    (succeeded, error) -> Void in
                    if error == nil {
                        // Hooray! Let them use the app now.
                        let alert = UIAlertView()
                        alert.title = "Registration Successful!"
                        alert.message = "You will now be logged in."
                        alert.addButtonWithTitle("Ok")
                        alert.show()
                    }
                }
            }
        })
        self.performSegueWithIdentifier("SignedUp", sender: self)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        registerUser()
        if ((error) != nil)
        {
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
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
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
