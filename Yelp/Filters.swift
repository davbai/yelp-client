//
//  Filters.swift
//  Yelp
//
//  Created by David Bai on 9/23/14.
//  Copyright (c) 2014 David Bai. All rights reserved.
//

import Foundation

struct Filters {
    
    static var sectionSelected = [false, true, true, false]
    static var deal : Bool = false
    static var sortBy : Int = 0
    static var distance : Int = 0
    static var categories : [Bool] = [false, false, false, false, false, false, false, false, false]
    
    static var categoryValues = ["active", "auto", "education", "food", "health", "nightlife", "realestate", "restaurants", "shopping"]
    
    static func getDistance() -> Int {
        switch Filters.sortBy {
        case 0:
            return 0
        case 1:
            return 200
        case 2:
            return 600
        case 3:
            return 1610
        case 4:
            return 8050
        default:
            return 0
        }
    }
    
    static func getCategories() -> String {
        var categoryArray = [String]()
        for i in 0...8 {
            if Filters.categories[i] {
                categoryArray.append(categoryValues[i])
            }
        }
        return ",".join(categoryArray)
    }
    
    static func getParameters() -> NSDictionary {
        var params = NSMutableDictionary()
        params["sort"] = Filters.sortBy
        params["radius"] = Filters.getDistance()
        params["category_filter"] = Filters.getCategories()
        return params
    }
   
}
