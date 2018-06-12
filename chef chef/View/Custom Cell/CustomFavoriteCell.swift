//
//  CustomFavoriteCell.swift
//  chef chef
//
//  Created by Jonathan on 17/05/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit

class CustomFavoriteCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    
    
    @IBOutlet weak var cellTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
