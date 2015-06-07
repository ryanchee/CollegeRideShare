//
//  ProfileCollectionViewController.swift
//  CollegeRideShare
//
//  Created by Ryan Chee on 5/27/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import UIKit

//let reuseIdentifier = "trip"

class ProfileCollectionViewController: UICollectionViewController {
    var trips: [Trip] = []
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
    }

    @IBOutlet var tripsCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        populateTripsArray()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

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
        
        cell.driverName.text = PFUser.currentUser()!.username
        cell.destination.text = trip.destination
        cell.price.text = "\(trip.price)"
        cell.departureDetails.text = trip.departureTime
        cell.departureDate.text = trip.departureDateString
        // Configure the cell
    
        return cell
    }
    
    
    func populateTripsArray() {
        var query = PFQuery(className:"Trips")
        query.whereKey("Driver", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock { [unowned self] (objects:[AnyObject]?, error:NSError?) -> Void in
            let objects = objects as! [PFObject]
            println("we have \(objects.count) objects)")
            for object in objects {
                let tripToAdd = Trip()

                tripToAdd.destination = object["Destination"] as! String
                tripToAdd.price = object["Price"] as! Int
                tripToAdd.departureTime = object["DepartureTime"] as! String
                tripToAdd.departureDateString = object["DepartureDateString"] as! String
                //                tripToAdd.currentRiders = ["object.CurrentRiders"] as! [User]
                //                tripToAdd.maxDropOffDistance = ["object.MaxDropOffDistance"] as! Int
                self.trips.append(tripToAdd)
            }
            self.tripsCollectionView.reloadData()
        }
        
    }
    
    func setProfileImage(view: UIImageView) -> Void {
        var query = PFQuery(className:"_User")
        println("username is: \(PFUser.currentUser()!.username!)")
        query.whereKey("username", equalTo:PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock ({(objects:[AnyObject]?, error: NSError?) in
            if(error == nil){
                let imageObjects = objects as! [PFObject]
                println("this amny objects \(imageObjects.count)")
                for object in imageObjects {
                    println("for loops")
                    let thumbNail = object["Image"]         as! PFFile
                    println("we got \(imageObjects.count) images!")
                    thumbNail.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error: NSError?) -> Void in
                        if (error == nil) {
                            if let image = UIImage(data:imageData!) {
                                println("got image")
                                view.image = image
                                return
                            }
                        }
                    })//getDataInBackgroundWithBlock - end
                    
                }//for - end
//                self.collectionView!.reloadData()
            }
            else{

                println("Error in retrieving \(error)")
            }
        })//findObjectsInBackgroundWithblock - end
        return

    }

    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> ProfileCollectionReusableView {
        var reusableview: ProfileCollectionReusableView?
        
        if (kind == UICollectionElementKindSectionHeader) {
            reusableview = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "ProfileHeader", forIndexPath: indexPath) as? ProfileCollectionReusableView
            setProfileImage(reusableview!.profileImage)
            reusableview?.numberOfPosts.text = "\(trips.count)"
            reusableview?.numberOfReviews.text = "1322"
//            NSString *title = [[NSString alloc]initWithFormat:@"Recipe Group #%i", indexPath.section + 1];
//            headerView.title.text = title;
//            UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
//            headerView.backgroundImage.image = headerImage;
//            
        }
        return reusableview!
        
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
