//
//  EditProfileViewController.swift
//  CollegeRideShare
//
//  Created by Yemane Gebreyesus on 5/30/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var homeTown: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var car: UITextField!
    @IBOutlet weak var numSeats: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var preferredname: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setProfileFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func changeProfilePhoto(sender: AnyObject) {
        let alertController: UIAlertController = UIAlertController(title: "Choose photo from...", message: nil, preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { [unowned self] action -> Void in
            //Do some stuff
        }
        alertController.addAction(cancelAction)
        //Create and an option action
        let camera = UIAlertAction(title: "Camera", style: .Default) { [unowned self] (_) in
            let picker = UIImagePickerController()
            picker.delegate = self
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                picker.sourceType = .Camera
            }
            else {
                picker.sourceType = .PhotoLibrary
            }
            self.presentViewController(picker, animated: true, completion: nil)
        }
        let photoalbum = UIAlertAction(title: "Photo Album", style: .Default) { [unowned self] (_) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .PhotoLibrary
            picker.allowsEditing = false
            self.presentViewController(picker, animated: true, completion: nil)
        }


        alertController.addAction(camera)
        alertController.addAction(photoalbum)
        
        //Present the AlertController
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        println("we got an image\n");
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        profileImageView.image = chosenImage
        dismissViewControllerAnimated(true, completion: nil) //5

//        setProfileFields()
        //reload datat here
        //self.collectionViewTable.reloadData()
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
        
        if let userPreferredName = user?["preferredname"] as? String {
            preferredname.text = userPreferredName
        }
        
        if let userImage = user?["Image"] as? PFFile {
            profileImageView.image = UIImage(data: userImage.getData()!)
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
        
        if let photo = profileImageView.image {
            let imageData = UIImagePNGRepresentation(photo)
            let imageFile = PFFile(name:"image.png", data: imageData)
            user?["Image"] = imageFile
        }
        
        if let homeTown = homeTown.text {
            user?["homeTown"] = homeTown
        }
        
        if let phoneNumber = phoneNumber.text {
            user?["phoneNumber"] = phoneNumber
        }
        
        if let preferredName = preferredname.text {
            user?["preferredname"] = preferredName
        }
        
        if let car = car.text {
            if let seats = numSeats.text {
                var userCar = PFObject(className:"Car")
                userCar["carModel"] = car
                userCar["numberOfSeats"] = seats.toInt()
                user?["car"] = userCar
            }
        }
//        user?.saveInBackground()
        user?.saveInBackgroundWithBlock { [unowned self]
            (succeeded, error) -> Void in
            if error == nil {
                // Hooray! Let them use the app now.
                let alert = UIAlertView()
                alert.title = "Profile saved!"
                alert.addButtonWithTitle("Ok")
                alert.show()
            }
            else {
                let alert = UIAlertView()
                alert.title = "Error"
                alert.message = "There was an error saving your data."
                alert.addButtonWithTitle("Ok")
                alert.show()
                // Show the errorString somewhere and let the user try again.
            }
        }
    }
}
