//
//  Specimen.swift
//  RWRealmStarterProject
//
//  Created by Ziyang Tan on 7/18/15.
//  Copyright (c) 2015 Bill Kastanakis. All rights reserved.
//

import UIKit
import RealmSwift

class Specimen: Object {
    dynamic var name = ""
    dynamic var specimenDescription = ""
    dynamic var latitude: Double = 0.0
    dynamic var longtitude: Double = 0.0
    dynamic var created = NSDate()
    dynamic var category = Category()
    dynamic var distance: Double = 0
    
    override static func ignoredProperties() -> [String] {
        return ["distance"]
    }
}
