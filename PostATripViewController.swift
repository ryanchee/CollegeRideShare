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
    
    @IBOutlet weak var departureDateMonthTextField: UITextField!
    @IBOutlet weak var departureDateDayTextField: UITextField!
    @IBOutlet weak var departureDateYearTextField: UITextField!
    
    @IBAction func postButton(sender: AnyObject) {
        var currentUser = PFUser.currentUser()!.username
        var userObj: User?
        
        if checkDataFields() == false {
            presentEmptyFieldsMessage()
        }
        
        else {
            var trip = PFObject(className:"Trips")
    //        trip["Driver"] = userObj?.name
            trip["Destination"] = destinationTextField.text
            destinationTextField.text = ""
            trip["Price"] = priceTextField.text.toInt()
            priceTextField.text = ""
            trip["DepartureTime"] = departureTimeTextField.text
            departureTimeTextField.text = ""
            trip["NumberOfSeats"] = numberOfSeatsTextField.text.toInt()
            numberOfSeatsTextField.text = ""
            trip["MaxDropOffDistance"] = maxDropOffDistTextField.text.toInt()
            maxDropOffDistTextField.text = ""
            var dateString = departureDateMonthTextField.text + "-" + departureDateDayTextField.text + "-" + departureDateYearTextField.text
            departureDateYearTextField.text = ""
            departureDateMonthTextField.text = ""
            departureDateDayTextField.text = ""
            trip["DepartureDateString"] = dateString
            // check how to use Date in parse trip["DepartureDate"]
            
            
            
            
            trip.saveInBackgroundWithTarget(nil, selector: nil)
            presentSaveConfirmation()
        }
    }
    
    func checkDataFields() -> Bool {

        if destinationTextField.text == "" {
            return false
        }
        else if maxDropOffDistTextField.text == "" {
            return false
        }
        else if priceTextField.text == "" {
            return false
        }
        else if departureTimeTextField.text == "" {
            return false
        }
        else if departureDateMonthTextField.text == "" || departureDateMonthTextField.text.toInt() == nil {
            return false
        }
        else if departureDateDayTextField.text == "" || departureDateDayTextField.text.toInt() == nil {
            return false
        }
        else if departureDateYearTextField.text == "" || departureDateYearTextField.text.toInt() == nil {
            return false
        }
        else if numberOfSeatsTextField.text == "" {
            return false
        }
        else {
            println("returning true")
            return true
        }
    }
    
    func presentEmptyFieldsMessage() -> Void {
        let actionSheetController: UIAlertController = UIAlertController(title: "Error With Submission", message: "One or more data field(s) are empty", preferredStyle: .Alert)
        //Create and an option action
        let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Default) { [unowned self] action -> Void in
        }
        actionSheetController.addAction(okAction)
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    func presentSaveConfirmation() -> Void {
        let actionSheetController: UIAlertController = UIAlertController(title: "Success!", message: "Your trip has been posted.", preferredStyle: .Alert)
        //Create and an option action
        let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Default) { [unowned self] action -> Void in
            self.tabBarController!.selectedIndex = 0;
        }
        actionSheetController.addAction(okAction)
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)

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
