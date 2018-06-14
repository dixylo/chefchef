//
//  CustomButton.swift
//  chef chef
//
//  Created by Xiaofeng Lin on 13/06/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    override func didMoveToWindow() {
        //self.backgroundColor = UIColor.darkGray
        self.layer.cornerRadius = self.frame.height / 2
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
