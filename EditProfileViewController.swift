//
//  EditProfileViewController.swift
//  CollegeRideShare
//
//  Created by Yemane Gebreyesus on 5/30/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    @IBOutlet weak var homeTown: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var car: UITextField!
    @IBOutlet weak var numSeats: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setProfileFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func setProfileFields() {
        var user = PFUser.currentUser()
        
        if let userHomeTown = user?["homeTown"] as? String {
            homeTown.text = userHomeTown
        }
        
        if let userPhone = user?["phoneNumber"] as? String {
            phoneNumber.text = userPhone
        }
        
        var query = PFQuery(className:"Car")
        
        query.getObjectInBackgroundWithId(user?["car"]?.objectId as! String!!) {
            (userCar: PFObject?, error: NSError?) -> Void in
            if error == nil && userCar != nil {
                println(userCar)
                self.car.text = userCar?["carModel"] as! String
                let userNumSeats:Int = userCar?["numberOfSeats"] as! Int
                self.numSeats.text = "\(userNumSeats)"
            }
        }

    }
    
    @IBAction func UpdateUser(sender: AnyObject) {
        var user = PFUser.currentUser()
        
        if let homeTown = homeTown.text {
            user?["homeTown"] = homeTown
        }
        
        if let phoneNumber = phoneNumber.text {
            user?["phoneNumber"] = phoneNumber
        }
        
        if let car = car.text {
            if let seats = numSeats.text {
                var userCar = PFObject(className:"Car")
                userCar["carModel"] = car
                userCar["numberOfSeats"] = seats.toInt()
                user?["car"] = userCar
            }
        }
        
        user?.saveInBackground()
    }
}