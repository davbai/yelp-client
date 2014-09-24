//
//  SwitchTableViewCell.swift
//  Yelp
//
//  Created by David Bai on 9/23/14.
//  Copyright (c) 2014 David Bai. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var optionSwitch: UISwitch!
    @IBOutlet weak var optionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
