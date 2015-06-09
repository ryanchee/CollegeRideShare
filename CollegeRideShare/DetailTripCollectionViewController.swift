//
//  DetailTripCollectionViewController.swift
//  
//
//  Created by Ryan Chee on 5/30/15.
//
//

import UIKit

//let reuseIdentifier = "Cell"

class DetailTripCollectionViewController: UICollectionViewController {
    var trip: Trip?
    var driver: PFUser!
    var currentRiderIds: [String]?
    @IBOutlet var riderCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize driver
        var query = PFUser.query()
        query!.whereKey("objectId", equalTo:trip!.driver!.objectId!)
        driver = (query?.getFirstObject() as! PFUser)
        
        if currentRiderIds == nil {
            currentRiderIds = [String]()
        }
        
        currentRiderIds!.removeAll(keepCapacity: true)
        
        if let riderArray = trip!.currentRiders {
            for rider in riderArray {
                currentRiderIds!.append(rider.objectId!)
            }
        }
        
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
        return currentRiderIds!.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("rider", forIndexPath: indexPath) as! RiderCollectionViewCell
        
        if currentRiderIds!.count > 0 {
            let riderUser = currentRiderIds![indexPath.row]
            let riderQuery = PFUser.query()
            riderQuery!.whereKey("objectId", equalTo: riderUser)
        
            cell.riderPhoto.image = UIImage(data: (driver["Image"] as! PFFile).getData()!)
            cell.riderName.text = riderUser
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> TripCollectionReusableView {
        var reusableview: TripCollectionReusableView?
        
        if (kind == UICollectionElementKindSectionHeader) {
            reusableview = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "TripHeader", forIndexPath: indexPath) as? TripCollectionReusableView
            
            reusableview?.driverPhoto.image = UIImage(data: (driver["Image"] as! PFFile).getData()!)
            if let preferredname = driver["preferredname"] as? String {
                reusableview?.driverName.text = preferredname
            }
            else {
                reusableview?.driverName.text = driver.username
            }
            reusableview?.destination.text = trip!.destination
            reusableview?.price.text = "\(trip!.price)"
            reusableview?.departureDetails.text = trip!.departureTime
            reusableview?.departureDate.text = trip!.departureDateString
            // Configure the cell
 
            //            NSString *title = [[NSString alloc]initWithFormat:@"Recipe Group #%i", indexPath.section + 1];
            //            headerView.title.text = title;
            //            UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
            //            headerView.backgroundImage.image = headerImage;
            //
        }
        else {
            //
        }
        
        return reusableview!
        
    }
    
    @IBAction func onSignUpPressed(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "\(driver.username!)'s Trip", message: "You are signing up for a trip to \(trip!.destination).", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            var query = PFQuery(className:"Trips")
            query.getObjectInBackgroundWithId(self.trip!.objectId) {
                [unowned self] (tripToUpdate: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    println(error)
                }
                else if let tripToUpdate = tripToUpdate {
                    tripToUpdate.addUniqueObject(PFUser.currentUser()!, forKey:"CurrentRiders")
                    tripToUpdate.saveInBackgroundWithBlock {
                        (success, error) -> Void in
                        if success {
                            self.currentRiderIds!.append(PFUser.currentUser()!.objectId!)
                            self.riderCollectionView.reloadData()
                        }
                        else {
                            NSLog("%@", error!)
                        }
                    }
                }
            }
        }
                
        if contains(currentRiderIds!, PFUser.currentUser()!.objectId!) {
            alertController.message = "You have already signed up for this trip."
        }
        else if currentRiderIds!.count == trip?.numSeats {
            alertController.message = "The seats on this trip have already been filled."
        }
        else {
            alertController.addAction(OKAction)
        }
        
        self.presentViewController(alertController, animated: true) {
            // ...
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
