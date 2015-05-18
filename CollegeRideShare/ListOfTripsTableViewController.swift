//
//  ListOfTripsTableViewController.swift
//  CollegeRideShare
//
//  Created by Ryan Chee on 5/17/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import UIKit

class ListOfTripsTableViewController: UITableViewController {

    @IBOutlet var tripsTableView: UITableView!
    var trips: [Trip] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        populateTripsArray()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return trips.count
    }
    


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TripTableViewCell = tableView.dequeueReusableCellWithIdentifier("TripCell", forIndexPath: indexPath) as! TripTableViewCell
        let trip = trips[indexPath.row]
        cell.driverName.text = PFUser.currentUser()!.username
        cell.destination.text = trip.destination
        cell.price.text = "\(trip.price)"
        cell.departureDetails.text = trip.departureTime

        // Configure the cell...

        return cell
    }

    
    func populateTripsArray() {
        var query = PFQuery(className:"Trips")
        query.findObjectsInBackgroundWithBlock { [unowned self] (objects:[AnyObject]?, error:NSError?) -> Void in
            let objects = objects as! [PFObject]
            println("we have \(objects.count) objects)")
            for object in objects {
                let tripToAdd = Trip()
                tripToAdd.destination = object["Destination"] as! String
                tripToAdd.price = object["Price"] as! Int
                tripToAdd.departureTime = object["DepartureTime"] as! String
//                tripToAdd.currentRiders = ["object.CurrentRiders"] as! [User]
//                tripToAdd.maxDropOffDistance = ["object.MaxDropOffDistance"] as! Int
                self.trips.append(tripToAdd)
            }
            self.tripsTableView.reloadData()
        }
        
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
