//
//  FilterResultsTableViewController.swift
//  Yelp
//
//  Created by David Bai on 9/21/14.
//  Copyright (c) 2014 David Bai. All rights reserved.
//

import UIKit

class FilterResultsTableViewController: UITableViewController {
    
    var sortByValues = ["Best Match", "Distance", "Rating", "Most Reviewed"]
    var distanceValues = ["Auto", "2 Blocks", "6 Blocks", "1 Mile", "5 Miles"]
    var categoryValues = ["Active Life", "Automative", "Education", "Food", "Health & Medical", "Nightlife", "Real Estate", "Restaurants", "Shopping"]
    
    var filterDelegate : FilterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let checkCellNib = UINib(nibName: "CheckTableViewCell", bundle: nil);
        self.tableView.registerNib(checkCellNib, forCellReuseIdentifier: "checkCell")
        
        let switchCellNib = UINib(nibName: "SwitchTableViewCell", bundle: nil);
        self.tableView.registerNib(switchCellNib, forCellReuseIdentifier: "switchCell")
    }


    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var indexPathArray = [NSIndexPath]()
        switch indexPath.section {
        case 1: // sort by
            for i in 0...3 {
                let newIndexPath = NSIndexPath(forRow: i, inSection: indexPath.section)
                indexPathArray.append(newIndexPath)
            }
            
            Filters.sortBy = indexPath.row
            
            if Filters.sectionSelected[indexPath.section] {
                Filters.sectionSelected[indexPath.section] = false;
                self.tableView.beginUpdates()
                self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow:0, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.Fade)
                self.tableView.insertRowsAtIndexPaths(indexPathArray, withRowAnimation: UITableViewRowAnimation.Middle)
                self.tableView.endUpdates()
            } else {
                Filters.sectionSelected[indexPath.section] = true;
                self.tableView.beginUpdates()
                self.tableView.deleteRowsAtIndexPaths(indexPathArray, withRowAnimation: UITableViewRowAnimation.Middle)
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow:0, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.Fade)
                self.tableView.endUpdates()
            }
        case 2: // distance
            for i in 0...4 {
                let newIndexPath = NSIndexPath(forRow: i, inSection: indexPath.section)
                indexPathArray.append(newIndexPath)
            }
            
            Filters.distance = indexPath.row
            
            if Filters.sectionSelected[indexPath.section] {
                Filters.sectionSelected[indexPath.section] = false;
                self.tableView.beginUpdates()
                self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow:0, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.Fade)
                self.tableView.insertRowsAtIndexPaths(indexPathArray, withRowAnimation: UITableViewRowAnimation.Middle)
                self.tableView.endUpdates()
            } else {
                Filters.sectionSelected[indexPath.section] = true;
                self.tableView.beginUpdates()
                self.tableView.deleteRowsAtIndexPaths(indexPathArray, withRowAnimation: UITableViewRowAnimation.Middle)
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow:0, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.Fade)
                self.tableView.endUpdates()
            }
        default:
            break
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1: // sort by
            let row = Filters.sectionSelected[1] ? 1 : 4
            return row
        case 2: // distance
            let row = Filters.sectionSelected[2] ? 1 : 5
            return row
        case 3: // categories
            let row = Filters.sectionSelected[3] ? 9 : 5
            return row
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            var cell = self.tableView.dequeueReusableCellWithIdentifier("switchCell") as SwitchTableViewCell
            cell.optionLabel.text = "Offering a deal"
            cell.optionSwitch.on = Filters.deal
            return cell
        case 1: // sort by
            var cell = self.tableView.dequeueReusableCellWithIdentifier("checkCell") as CheckTableViewCell
            cell.accessoryType = UITableViewCellAccessoryType.None
            if Filters.sectionSelected[indexPath.section] {
                cell.optionLabel.text = self.sortByValues[Filters.sortBy]
            } else {
                cell.optionLabel.text = self.sortByValues[indexPath.row]
            }
            return cell
        case 2: // distance
            var cell = self.tableView.dequeueReusableCellWithIdentifier("checkCell") as CheckTableViewCell
            cell.accessoryType = UITableViewCellAccessoryType.None
            if Filters.sectionSelected[indexPath.section] {
                cell.optionLabel.text = self.distanceValues[Filters.distance]
            } else {
                cell.optionLabel.text = self.distanceValues[indexPath.row]
            }
            return cell
        case 3: // categories
            var cell = self.tableView.dequeueReusableCellWithIdentifier("switchCell") as SwitchTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.optionSwitch.setOn(Filters.categories[indexPath.row], animated: false)
            cell.optionSwitch.addTarget(self, action: "setCategory:", forControlEvents: UIControlEvents.ValueChanged)
            cell.optionSwitch.tag = indexPath.row
            cell.optionLabel.text = categoryValues[indexPath.row]
            return cell
        default:
            var cell = self.tableView.dequeueReusableCellWithIdentifier("checkCell") as CheckTableViewCell
            cell.accessoryType = UITableViewCellAccessoryType.None
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 3 {
            if Filters.sectionSelected[section] {
                return nil
            }
            var footerView = UIView()
            footerView.frame = CGRectMake(0, 0, tableView.frame.width, 40)
            let button = UIButton(frame: footerView.bounds)
            
            button.setTitle("See All", forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.layer.backgroundColor = UIColor.whiteColor().CGColor
            button.addTarget(self, action: "seeAllCategories:", forControlEvents: UIControlEvents.TouchUpInside)
            
            footerView.addSubview(button)
            return footerView
        }
        return nil
    }
    
    func seeAllCategories(sender: AnyObject?) {
        Filters.sectionSelected[3] = true
        var indexPathArray = [NSIndexPath]()
        for i in 5...8 {
            let newIndexPath = NSIndexPath(forRow: i, inSection: 3)
            indexPathArray.append(newIndexPath)
        }
        self.tableView.insertRowsAtIndexPaths(indexPathArray, withRowAnimation: UITableViewRowAnimation.Top)
    }
    
    func setCategory(sender: AnyObject?) {
        let optionSwitch = sender as UISwitch
        let index = optionSwitch.tag
        Filters.categories[index] = optionSwitch.on
        
        println(Filters.categories)
    }
    
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func filterSearch(sender: AnyObject) {
        self.filterDelegate?.applyFilters()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
