//
//  ModelObjects.swift
//  CollegeRideShare
//
//  Created by Ryan Chee on 5/17/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import Foundation

class User {
    var name: String!
    var homeTown: String!
    var coordinates: [Double]?
    var phoneNumber: String!
    var postedTrips: [Trip]?
    var car: Car?
    var mutualFriends: [User]?
}

class Car {
    var carModel: String!
    var numberOfSeats: Int!
}

class Trip {
    var driver: PFUser!
    var destination: String!
    var price: Int!
    var departureTime: String!
    var departureDateString: String!
    var departureDate: NSDate!
    var currentRiders: [PFUser]?
    var numSeats: Int!
    var maxDropOffDistance: Int!
    var objectId: String!
}