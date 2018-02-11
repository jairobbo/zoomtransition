//
//  Cell.swift
//  Zoomtransition
//
//  Created by Jairo Bambang Oetomo on 04-02-18.
//  Copyright © 2018 Jairo Bambang Oetomo. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
