//
//  DealCellTableViewCell.swift
//  DesidimeDemo
//
//  Created by Akanksha Sharma on 03/06/15.
//  Copyright (c) 2015 akanksha. All rights reserved.
//

import UIKit

class DealCellTableViewCell: UITableViewCell {
    @IBOutlet weak var dealDescription: UILabel!
    @IBOutlet weak var dealTitle: UILabel!
    @IBOutlet weak var dealImage: UIImageView!
    @IBOutlet weak var imgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
