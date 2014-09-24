//
//  BusinessTableViewController.swift
//  Yelp
//
//  Created by David Bai on 9/21/14.
//  Copyright (c) 2014 David Bai. All rights reserved.
//

import UIKit

class BusinessTableViewController: UITableViewController, UISearchBarDelegate, FilterDelegate {
        
    var client: YelpClient!
    
    var businesses : NSArray!
    
    let searchBar : UISearchBar = UISearchBar()
    
    // Configuration strings
    let config = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Configuration", ofType: "plist")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
        self.searchBar.delegate = self
        self.navigationItem.titleView = self.searchBar
        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("showFilterResultsView"))

        // Do any additional setup after loading the view, typically from a nib.
        client = YelpClient(consumerKey: config["Yelp Consumer Key"] as String, consumerSecret: config["Yelp Consumer Secret"] as String, accessToken: config["Yelp Token"] as String, accessSecret: config["Yelp Token Secret"] as String)
        
        self.searchBar.text = "Restaurants"
        client.searchWithTerm("Restaurants", success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            self.businesses = response["businesses"] as NSArray
            self.tableView.reloadData()
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }
    
    func showFilterResultsView() {
//        var filterView = FilterResultsTableViewController()
//        filterView.navigationController = self.navigationController
//        self.navigationController?.presentViewController(FilterResultsTableViewController(), animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.businesses != nil {
            return self.businesses.count
        }
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("businessCell", forIndexPath: indexPath) as BusinessTableViewCell

        var business = self.businesses[indexPath.row] as NSDictionary
        
        if business["image_url"] != nil {
            cell.businessImageView.setImageWithURL(NSURL(string: business["image_url"] as String))
        }
        cell.ratingImageView.setImageWithURL(NSURL(string: business["rating_img_url_large"] as String))
        
        let name = business["name"] as String
        cell.nameLabel.text = "\(indexPath.row + 1). \(name)"
        
        let reviewCount = business["review_count"] as Int
        cell.reviewCountLabel.text = "\(reviewCount) Reviews"
        cell.reviewCountLabel.sizeToFit()
        
        let location = business["location"] as NSDictionary
        
        let neighborhood = location["neighborhoods"] as NSArray
        let address = location["address"] as NSArray
        cell.addressLabel.text = "\(address[0]), \(neighborhood[0])"
        
        var categories : Array = []
        var categoriesData = business["categories"] as NSArray
        
        for cat in categoriesData {
            categories.append(cat[0])
        }
        
        cell.categoriesLabel.text = ", ".join(categories.map({ "\($0)" }))
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "filterSegue" {
            var filterVC = segue.destinationViewController.childViewControllers[0] as FilterResultsTableViewController
            filterVC.filterDelegate = self;
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let loadingView = GKPopLoadingView()
        loadingView.show(true, withTitle: "Loading")
        
        self.searchBar.resignFirstResponder()
        
        client.searchWithTerm(searchBar.text, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            self.businesses = response["businesses"] as NSArray
            self.tableView.reloadData()
                loadingView.show(false, withTitle: "")
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }
    
    func applyFilters() {
        let loadingView = GKPopLoadingView()
        loadingView.show(true, withTitle: "Loading")
        
        var parameters = ["term": self.searchBar.text, "location": "San Francisco"] as NSMutableDictionary
        parameters.addEntriesFromDictionary(Filters.getParameters())
        
        client.searchWithParams(parameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            self.businesses = response["businesses"] as NSArray
            println(self.businesses)
            self.tableView.reloadData()
            loadingView.show(false, withTitle: "")
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }
}

protocol FilterDelegate {
    func applyFilters()
}
