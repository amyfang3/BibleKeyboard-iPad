//
//  VerseTextField.swift
//  BibleKeyboard-iPad
//
//  Created by Amy Fang on 2/18/19.
//  Copyright © 2019 Amy Fang. All rights reserved.
//

import UIKit

class VerseTextField: UITextField {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.autocorrectionType = .no
        self.placeholder = "1"
        self.font = UIFont.systemFont(ofSize: 18)
    }
    
    func changeToErrorUI(){
        self.backgroundColor = UIColor.init(red: 247/255, green: 128/255, blue: 142/255, alpha: 1.0)
    }
    
    func changeToNormalUI(){
        self.backgroundColor = UIColor.white
    }
}

