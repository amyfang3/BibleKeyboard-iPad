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
        
        // Constraints pinning bibleKeyboardView to the superview are added and activated
        bibleKeyboardView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the keyboard to a container view so that it's sized correctly
        textView.inputView = bibleKeyboardView
        
        // Constraints pinning bibleKeyboardView to the superview are added and activated
        bibleKeyboardView.translatesAutoresizingMaskIntoConstraints = false
        bibleKeyboardView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        //NSLayoutConstraint.activate([
            //bibleKeyboardView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width)
//            bibleKeyboardView.leftAnchor.constraint(equalTo: UIScreen.main.bounds.),
//            bibleKeyboardView.rightAnchor.constraint(equalTo: inputView.rightAnchor),
//            bibleKeyboardView.topAnchor.constraint(equalTo: inputView.topAnchor),
//            bibleKeyboardView.bottomAnchor.constraint(equalTo: inputView.bottomAnchor),
            //])
        
        
        
        // makes the keyboard pop up immediately
        textView.becomeFirstResponder()
        textView.autocorrectionType = .no
        textView.inputAssistantItem.leadingBarButtonGroups.removeAll()
        textView.inputAssistantItem.trailingBarButtonGroups.removeAll()
    }
    
    @IBAction func clearBtn(_ sender: Any) {
        textView.text = ""
    }
    
    
    func submitButtonWasTapped(passage: String) {
        textView.insertText(passage)
    }
    
    func newlineButtonWasTapped() {
        textView.insertText("\n")
    }
}

