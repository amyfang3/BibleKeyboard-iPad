//
//  BibleSection.swift
//  BibleKeyboard-iPad
//
//  Created by Amy Fang on 2/17/19.
//  Copyright © 2019 Amy Fang. All rights reserved.
//

import Foundation

class BibleSection {
    var title: String?
    var bookList: Array<String>?
    
    init(sectionName: String, list: Array<String>) {
        title = sectionName
        bookList = list
    }
}
