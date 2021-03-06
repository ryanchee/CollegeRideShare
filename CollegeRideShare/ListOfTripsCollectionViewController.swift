//
//  ListOfTripsCollectionViewController.swift
//  CollegeRideShare
//
//  Created by Ryan Chee on 5/28/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class ListOfTripsCollectionViewController: UICollectionViewController {

    var trips: [Trip] = []

    @IBOutlet var tripsCollectionView: UICollectionView!
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        if let view = recognizer.view {
            if recognizer.state == UIGestureRecognizerState.Ended {
                println("in reload view")
                trips = []
                populateTripsArray()
                view.setNeedsDisplay()
            }
        }
    }
    override func viewWillAppear(animated: Bool) {
        trips = []
        populateTripsArray()
        self.tripsCollectionView.reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        

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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return trips.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("trip", forIndexPath: indexPath) as! TripCollectionViewCell
        
        let trip = trips[indexPath.row]
        //        cell.driverPhoto.image = UIImage(data: <#NSData#>)
        //getProfileImage()
        
        var query = PFUser.query()
        query!.whereKey("objectId", equalTo:trip.driver.objectId!)
        var driver = (query?.getFirstObject() as! PFUser)
        
        cell.driverPhoto.image = UIImage(data: (driver["Image"] as! PFFile).getData()!)
        if let preferredname = driver["preferredname"] as? String {
            cell.driverName.text = preferredname
        }
        else {
            cell.driverName.text = driver.username
        }
        cell.destination.text = trip.destination
        cell.price.text = "\(trip.price)"
        cell.departureDetails.text = trip.departureTime
        cell.departureDate.text = trip.departureDateString
        // Configure the cell
        
        return cell
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "detailtrip" {
            let dest = segue.destinationViewController as! DetailTripCollectionViewController
            let cell = sender as! TripCollectionViewCell
            let index = self.tripsCollectionView.indexPathForCell(cell)!.row
            println("index is \(index)")
            dest.trip = trips[index]
            
            println("\(segue.identifier!)")
        }
        
    }
    
    
    func populateTripsArray() {
        var query = PFQuery(className:"Trips")
        //need to change to Driver.name
        //        query.whereKey("Destination", equalTo: PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock { [unowned self] (objects:[AnyObject]?, error:NSError?) -> Void in
            let objects = objects as! [PFObject]
            println("we have \(objects.count) objects")
            for object in objects {
                var date = object["DepartureDate"] as! NSDate
//                println("\(date) compared to \(NSDate())")
                if date.compare(NSDate()) == NSComparisonResult.OrderedDescending {
                    let tripToAdd:Trip = Trip()
                    tripToAdd.driver = object["Driver"] as! PFUser
                    tripToAdd.destination = object["Destination"] as! String
                    tripToAdd.price = object["Price"] as! Int
                    tripToAdd.departureTime = object["DepartureTime"] as! String
                    tripToAdd.departureDateString = object["DepartureDateString"] as! String
                    tripToAdd.departureDate = object["DepartureDate"] as! NSDate
                    tripToAdd.objectId = object.objectId!
                    tripToAdd.currentRiders = object["CurrentRiders"] as? [PFUser]
                    tripToAdd.numSeats = object["NumberOfSeats"] as! Int
                    //let eqe = tripToAdd.driver["Car"]
                    //print(eqe)
                    
                    //                tripToAdd.maxDropOffDistance = ["object.MaxDropOffDistance"] as! Int
                    self.trips.append(tripToAdd)
                }
            }
            self.trips.sort({$0.departureDate.compare($1.departureDate) == NSComparisonResult.OrderedAscending})
            self.tripsCollectionView.reloadData()
        }
        
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
