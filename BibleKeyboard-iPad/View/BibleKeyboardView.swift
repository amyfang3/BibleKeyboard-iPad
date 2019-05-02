//
//  BibleKeyboardView.swift
//  BibleKeyboard-iPad
//
//  Created by Amy Fang on 2/12/19.
//  Copyright © 2019 Amy Fang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol BibleVerseKeyboardViewDelegate: class {
    func submitButtonWasTapped(passage: String)
    func newlineButtonWasTapped()
}

class BibleKeyboardView: UIView, UIScrollViewDelegate {
    
    let ESV_API_KEY = "c70c9178f42aa8b69ec9cd6dcd96962cbd3d008c"
    let ESV_API_URL = "https://api.esv.org/v3/passage/text/"
    
    weak var delegate: BibleVerseKeyboardViewDelegate?
    var scrollView: UIScrollView!
    
    @IBOutlet weak var bookLabel: UILabel!
    
    @IBOutlet weak var verseReferenceTxtField: VerseTextField!
    
    @IBOutlet weak var nextKeyboardBtn: UIButton!
    @IBOutlet weak var verseNumsIncludedBtn: UISwitch!
    
    var activeField: UITextField?
    
    let oldTestament = ["Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy", "Joshua", "Judges", "Ruth", "1 Samuel", "2 Samuel", "1 Kings", "2 Kings", "1 Chronicles", "2 Chronicles", "Ezra", "Nehemiah", "Esther", "Job", "Psalms", "Proverbs", "Ecclesiastes", "Song of Solomon", "Isaiah", "Jeremiah", "Lamentations", "Ezekiel", "Daniel", "Hosea", "Joel", "Amos", "Obadiah", "Jonah", "Micah", "Nahum", "Habakkuk", "Zephaniah", "Haggai", "Zechariah", "Malachi"]
    
    let newTestament = ["Matthew", "Mark", "Luke", "John", "Acts", "Romans", "1 Corinthians", "2 Corinthians", "Galatians", "Ephesians", "Philippians", "Colossians", "1 Thessalonians", "2 Thessalonians", "1 Timothy", "2 Timothy", "Titus", "Philemon", "Hebrews", "James", "1 Peter", "2 Peter", "1 John", "2 John", "3 John", "Jude", "Revelation"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addScrollView()
        populateBooks()
        
        verseNumsIncludedBtn.onTintColor = UIColor.init(red: 192/255, green: 179/255, blue: 149/255, alpha: 1.0)
        
        verseReferenceTxtField.delegate = self
        verseReferenceTxtField.inputView = self
    }
    
    func setNextKeyboardVisible(_ visible: Bool){
        nextKeyboardBtn.isHidden = !visible
    }
    
    // MARK: - Book Tab Methods
    // adds scrollview which holds the books
    func addScrollView(){
        scrollView = UIScrollView(frame: CGRect(x: self.frame.minX + 70, y: self.frame.minY + 62, width: 575, height: self.frame.height))
        scrollView.showsVerticalScrollIndicator = true
        scrollView.backgroundColor = UIColor.init(red: 83/255, green: 83/255, blue: 83/255, alpha: 1.0)
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: self.frame.height - 62)
        scrollView.delegate = self
        
        
        addSubview(scrollView)
    }
    
    // creates all of the books
    func populateBooks(){
        
        // starting position for first book button
        var position = CGPoint(x: scrollView.frame.minX - 15, y: scrollView.frame.minY - 40)
        
        let sections = [BibleSection(sectionName: "Old Testament", list: oldTestament),
                        BibleSection(sectionName: "New Testament", list: newTestament)]
        
        // add OT and NT section
        for section in sections {
            
            // add Old/New Testament label
            let sectionLabel = SectionLabel(sectionTitle: section.title!, position: position)
            scrollView.addSubview(sectionLabel)
            
            // create space between section label and books
            position.y += 50
            
            // add books
            for book in section.bookList! {
                let buttonWidth = CGFloat(book.count * 12)
                
                // if button goes beyond keyboard frame bounds, return to next line
                if position.x + buttonWidth >= scrollView.frame.width - 10 {
                    position.x = scrollView.frame.minX  - 15
                    position.y += 45
                }
                
                // create button and add space between buttons
                let bookButton = BookButton(name: book, position: position)
                bookButton.addTarget(self, action: #selector(bookButtonTapped), for: .touchUpInside)
                scrollView.addSubview(bookButton)
                position.x += bookButton.frame.width + 5
            }
            
            // creates space between the two sections
            position.x = scrollView.frame.minX - 15
            position.y += 60
        }
        
        // adjusts scrollView height after all books have been added
        scrollView.contentSize.height = position.y + 10.0
    }
    
    // MARK: - Button Tapped Methods
    @objc func bookButtonTapped(sender: UIButton){
        
        // if there was an error before, remove error UI
        if bookLabel.backgroundColor != UIColor.clear {
            bookLabel.backgroundColor = UIColor.clear
        }
        
        bookLabel.text = sender.titleLabel?.text
    }
    
    // adds numbers to text fields
    @IBAction func numBtnTapped(_ sender: UIButton) {
        // if a text field is selected and # of chars is < 3, add a new character
        if let fieldCount = activeField?.text?.count {
            
            // Prevent users from inputting 0, -, or : as first char
            if fieldCount == 0 && (sender.titleLabel?.text! == "0" ||
                                   sender.titleLabel?.text! == "-" ||
                                    sender.titleLabel?.text! == ":") {
                print("Don't input if user tries to input first character as 0, -, :")
            } else {
                activeField?.text = (activeField?.text)! + (sender.titleLabel?.text!)!
            }
        }
    }
    
    @IBAction func deleteBtnTapped(_ sender: Any) {

        // if a text field is selected and has at least 1 char, delete last char
        if let textField = activeField {
            if (textField.text?.count)! > 0 {
                textField.text?.removeLast()
            }
        }
    }
    
    @IBAction func newlineBtnTapped(_ sender: Any) {
        self.delegate?.newlineButtonWasTapped()
    }
    
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        
        let passageReference = bookLabel.text! + verseReferenceTxtField.text!
        print("Passage reference: \(passageReference)")
        print(verseNumsIncludedBtn.isOn)
        
        getBiblePassage(passageReference: passageReference){ passage, error in
            self.delegate?.submitButtonWasTapped(passage: passage!)
        }
    }
    
    // MARK: - JSON Parsing Method
    func getBiblePassage(passageReference: String, completionHandler: @escaping (String?, Error?) -> ()) {
        let parameters:[String:Any] = ["q": passageReference,
                                       "include-passage-references": "true",
                                       "include-verse-numbers": String(verseNumsIncludedBtn.isOn),
                                       "include-footnotes": "false",
                                       "include-headings": "false"]
        
        let headers = ["Authorization":"Token \(ESV_API_KEY)"]
        
        var passage = ""
        
        Alamofire.request(ESV_API_URL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                print("\nSuccess! Got the Bible data\n")
                let passageJSON : JSON = JSON(value)
                
                //print(passageJSON["passages"][0].string!)
                passage = passageJSON["passages"][0].string!
                completionHandler(passage, nil)
            case .failure(let error):
                print(error)
                print("\nError, didn't get Bible data\n")
                passage = "Error, didn't get Bible data"
                completionHandler(nil, error)
            }
        }
    }
}

// MARK: - Extensions
extension BibleKeyboardView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
}

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        guard let strongSelf = self else {
            return true
        }
        return strongSelf.isEmpty ? true : false
    }
}

extension String {
    var isBookSelected: Bool {
        return self != "Choose a Book"
    }
}
