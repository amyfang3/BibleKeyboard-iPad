//
//  BookButton.swift
//  BibleKeyboard-iPad
//
//  Created by Amy Fang on 2/16/19.
//  Copyright © 2019 Amy Fang. All rights reserved.
//

import UIKit

class BookButton: UIButton {
    
    var buttonBackgroundColor: UIColor = UIColor.init(red: 192/255, green: 179/255, blue: 149/255, alpha: 1.0)
    var cornerRadius:CGFloat = 6
    let buttonWidthMultiplier:Int = 14
    let buttonHeight:CGFloat = 40
    
    init(name: String, position: CGPoint) {
        super.init(frame: CGRect(x: position.x, y: position.y, width: CGFloat(name.count * buttonWidthMultiplier), height: buttonHeight))
        self.setTitle(name, for: .normal)
        self.backgroundColor = buttonBackgroundColor
        self.layer.cornerRadius = cornerRadius
        self.setTitleColor(UIColor.darkGray, for: .highlighted)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
