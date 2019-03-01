//
//  ViewController.swift
//  BibleKeyboard-iPad
//
//  Created by Amy Fang on 2/12/19.
//  Copyright © 2019 Amy Fang. All rights reserved.
//

import UIKit

class AppViewController: UIViewController, BibleVerseKeyboardViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    
    var bibleKeyboardView: BibleKeyboardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Instantiate keyboard
        let nib = UINib(nibName: "BibleKeyboardView", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        bibleKeyboardView = objects.first as? BibleKeyboardView
        bibleKeyboardView.delegate = self
        
        bibleKeyboardView.setNextKeyboardVisible(false)
        
        // Add the keyboard to a container view so that it's sized correctly
        textView.inputView = bibleKeyboardView
        
        // makes the keyboard pop up immediately
        textView.becomeFirstResponder()
        textView.autocorrectionType = .no
    }
    
    func submitButtonWasTapped(passage: String) {
        textView.insertText(passage)
    }
    
    func newlineButtonWasTapped() {
        textView.insertText("\n")
    }
}

