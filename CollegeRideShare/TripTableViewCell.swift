//
//  TripTableViewCell.swift
//  CollegeRideShare
//
//  Created by Ryan Chee on 5/17/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {

    @IBOutlet weak var driverPhoto: UIImageView!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var departureDetails: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
