//
//  PlacesTableViewCell.swift
//  AirBnB Clone
//
//  Created by orlando arzola on 14.09.16.
//  Copyright © 2016 orlando arzola. All rights reserved.
//

import UIKit


class PlacesTableViewCell: UITableViewCell {

    @IBOutlet weak var placeImageView: UIImageView!
    
    @IBOutlet weak var placeTitleLabel: UILabel!
    
    @IBOutlet weak var placeTypeLabel: UILabel!
    
    @IBOutlet weak var placePriceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
