//
//  SectionLabel.swift
//  BibleKeyboard-iPad
//
//  Created by Amy Fang on 2/17/19.
//  Copyright © 2019 Amy Fang. All rights reserved.
//

import UIKit

class SectionLabel: UILabel {
    
    let height:CGFloat = 40
    
    init(sectionTitle: String, position: CGPoint){
        super.init(frame: CGRect(x: position.x, y: position.y, width: CGFloat(sectionTitle.count * 12), height: height))
        self.text = sectionTitle
        self.textColor = UIColor.white
        self.font = UIFont.boldSystemFont(ofSize: 20.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
