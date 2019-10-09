//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Amy Fang on 2/26/19.
//  Copyright © 2019 Amy Fang. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    // A property to hold reference to a MorseKeyboardView object
    var bibleKeyboardView: BibleKeyboardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // An instance of BibleKeyboardView is added to the controller's root inputView
        let nib = UINib(nibName: "BibleKeyboardView", bundle: nil)
        let objects = nib.instantiate(withOwner: nil, options: nil)
        bibleKeyboardView = (objects.first as! BibleKeyboardView)
        guard let inputView = inputView else { return }
        inputView.addSubview(bibleKeyboardView)
        
        // Constraints pinning bibleKeyboardView to the superview are added and activated
        bibleKeyboardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bibleKeyboardView.leftAnchor.constraint(equalTo: inputView.leftAnchor),
            bibleKeyboardView.rightAnchor.constraint(equalTo: inputView.rightAnchor),
            bibleKeyboardView.topAnchor.constraint(equalTo: inputView.topAnchor),
            bibleKeyboardView.bottomAnchor.constraint(equalTo: inputView.bottomAnchor),
            ])
        
        // controls visibility of the globe key
        bibleKeyboardView.setNextKeyboardVisible(needsInputModeSwitchKey)
        
        // adds automatic handle switching to glove key
        bibleKeyboardView.nextKeyboardBtn.addTarget(self,
                                                       action: #selector(handleInputModeList(from:with:)),
                                                       for: .allTouchEvents)

        bibleKeyboardView.delegate = self
    }
}

extension KeyboardViewController: BibleVerseKeyboardViewDelegate {
    func submitButtonWasTapped(passage: String) {
        textDocumentProxy.insertText(passage)
    }
    
    func newlineButtonWasTapped() {
        textDocumentProxy.insertText("\n")
    }
    
    func globeKeyButtonWasTapped() {
        // self.advanceToNextInputMode()
    }
}
