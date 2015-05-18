//
//  PostATripViewController.swift
//  CollegeRideShare
//
//  Created by Ryan Chee on 5/17/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import UIKit

class PostATripViewController: UIViewController {
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var departureTimeTextField: UITextField!
    @IBOutlet weak var maxDropOffDistTextField: UITextField!
    @IBOutlet weak var numberOfSeatsTextField: UITextField!
    @IBAction func postButton(sender: AnyObject) {
        var currentUser = PFUser.currentUser()!.username
        var userObj: User?
        
        var trip = PFObject(className:"Trips")
//        trip["Driver"] = userObj?.name
        trip["Destination"] = destinationTextField.text
        trip["Price"] = priceTextField.text.toInt()
        trip["DepartureTime"] = departureTimeTextField.text
        trip["NumberOfSeats"] = numberOfSeatsTextField.text.toInt()

        trip.saveInBackgroundWithTarget(nil, selector: nil)
        println("data has been saved to database")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

}
