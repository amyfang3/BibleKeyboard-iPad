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
    var tradScrollView: UIScrollView!
    var alphScrollView: UIScrollView!
    var segmentedCtrl: UISegmentedControl!
    var chosenBookBtn: UIButton!
    
    @IBOutlet weak var bookLabel: UILabel!
    @IBOutlet weak var verseReferenceLabel: UILabel!
    @IBOutlet weak var topBar: UILabel!
    
    @IBOutlet weak var nextKeyboardBtn: UIButton!
    @IBOutlet weak var verseNumsIncludedSwitch: UISwitch!
    @IBOutlet weak var isAlphaSwift: UISwitch!
    
    
    let oldTestament = ["Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy", "Joshua", "Judges", "Ruth", "1 Samuel", "2 Samuel", "1 Kings", "2 Kings", "1 Chronicles", "2 Chronicles", "Ezra", "Nehemiah", "Esther", "Job", "Psalms", "Proverbs", "Ecclesiastes", "Song of Solomon", "Isaiah", "Jeremiah", "Lamentations", "Ezekiel", "Daniel", "Hosea", "Joel", "Amos", "Obadiah", "Jonah", "Micah", "Nahum", "Habakkuk", "Zephaniah", "Haggai", "Zechariah", "Malachi"]
    
    let newTestament = ["Matthew", "Mark", "Luke", "John", "Acts", "Romans", "1 Corinthians", "2 Corinthians", "Galatians", "Ephesians", "Philippians", "Colossians", "1 Thessalonians", "2 Thessalonians", "1 Timothy", "2 Timothy", "Titus", "Philemon", "Hebrews", "James", "1 Peter", "2 Peter", "1 John", "2 John", "3 John", "Jude", "Revelation"]
    
    var screenWidth = UIScreen.main.bounds.size.width
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addTradScrollView()
        addAlphabeticalScrollView()
        
        verseNumsIncludedSwitch.onTintColor = UIColor.init(red: 192/255, green: 179/255, blue: 149/255, alpha: 1.0)
        isAlphaSwift.onTintColor = UIColor.init(red: 192/255, green: 179/255, blue: 149/255, alpha: 1.0)
        isAlphaSwift.setOn(false, animated: false)
        
        topBar.frame = CGRect(x: topBar.frame.origin.x, y: topBar.frame.origin.y, width: UIScreen.main.bounds.size.width, height: topBar.frame.size.height
        )
    }
    
    func setNextKeyboardVisible(_ visible: Bool){
        nextKeyboardBtn.isHidden = !visible
    }
    
    // MARK: - Book Tab Methods
    
    // adds scrollview which holds the books
    func addTradScrollView(){
        tradScrollView = UIScrollView(frame: CGRect(x: self.frame.minX + 70, y: self.frame.minY + 62, width: screenWidth / 2, height: self.frame.height))
        tradScrollView.showsVerticalScrollIndicator = true
        tradScrollView.backgroundColor = UIColor.init(red: 83/255, green: 83/255, blue: 83/255, alpha: 1.0)
        tradScrollView.contentSize = CGSize(width: tradScrollView.frame.width, height: self.frame.height - 62)
        tradScrollView.delegate = self
        populateBooks(tradScrollView)
        
        addSubview(tradScrollView)
    }
    
    func addAlphabeticalScrollView(){
        alphScrollView = UIScrollView(frame: CGRect(x: self.frame.minX + 70, y: self.frame.minY + 62, width: 575, height: self.frame.height))
        alphScrollView.showsVerticalScrollIndicator = true
        alphScrollView.backgroundColor = UIColor.init(red: 83/255, green: 83/255, blue: 83/255, alpha: 1.0)
        alphScrollView.contentSize = CGSize(width: alphScrollView.frame.width, height: self.frame.height - 62)
        alphScrollView.delegate = self
        populateBooks(alphScrollView)
        
        addSubview(alphScrollView)
        alphScrollView.isHidden = true
    }
    
    func populateBooks(_ scrollView:UIScrollView){
        var sections = [BibleSection]()
        if scrollView == tradScrollView {
            sections = [BibleSection(sectionName: "Old Testament", list: oldTestament),
                        BibleSection(sectionName: "New Testament", list: newTestament)]
        } else {
            sections = createAlphaSections()
        }
        
        addSections(sections, scrollView)
    }
    
    func createAlphaSections() -> [BibleSection]{
        var allBooksLst = oldTestament + newTestament
        allBooksLst.sort()
        
        var sections = [BibleSection]()
        
        var currentSectionTitle = "1"
        var currentList = [String]()
        
        for book in allBooksLst {
            
            if String(book[book.startIndex]) == currentSectionTitle {
                currentList.append(book)
            // new section
            } else {
                sections.append(BibleSection(sectionName: currentSectionTitle, list: currentList))
                currentSectionTitle = String(book[book.startIndex])
                currentList = [book]
            }
        }
        
        return sections
    }
    
    
    // creates all of the books
    func addSections(_ sections: [BibleSection], _ scrollView: UIScrollView){
        
        // starting position for first book button
        var position = CGPoint(x: scrollView.frame.minX - 15, y: scrollView.frame.minY - 40)
        
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
                if position.x + buttonWidth >= scrollView.frame.width - 20 {
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
        scrollView.contentSize.height = position.y + 70.0
    }
    
    // Switch book display
    @IBAction func changeBooksDisplay(_ sender: UISwitch) {
        // if alphabetical display
        if sender.isOn {
            alphScrollView.isHidden = false
            tradScrollView.isHidden = true
        // if traditional
        } else {
            alphScrollView.isHidden = true
            tradScrollView.isHidden = false
        }
    }
    
    
    // MARK: - Button Tapped Methods
    @objc func bookButtonTapped(sender: UIButton){
        
        // if a book was already selected
        if chosenBookBtn != nil {
            chosenBookBtn.layer.borderColor = UIColor.clear.cgColor
            chosenBookBtn.layer.shadowColor = UIColor.clear.cgColor
        }
        chosenBookBtn = sender
        chosenBookBtn.layer.borderColor = UIColor.white.cgColor
        chosenBookBtn.layer.shadowColor = UIColor.white.cgColor
        chosenBookBtn.layer.shadowOpacity = 0.8
        chosenBookBtn.layer.shadowRadius = 5
        chosenBookBtn.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        
        bookLabel.text = sender.titleLabel?.text
    }
    
    // adds numbers to text fields
    @IBAction func numBtnTapped(_ sender: UIButton) {
        
        // if a text field is selected and # of chars is < 3, add a new character
        if let fieldCount = verseReferenceLabel.text?.count {
            
            // Prevent users from inputting 0, -, or : as first char
            if fieldCount == 0 && (sender.titleLabel?.text! == "0" ||
                                   sender.titleLabel?.text! == "-" ||
                                    sender.titleLabel?.text! == ":") {
                print("Don't input if user tries to input first character as 0, -, :")
            }
            else if verseReferenceLabel.text == "Tap on a number" {
                verseReferenceLabel.text = (sender.titleLabel?.text!)!
            } else {
                verseReferenceLabel.text = (verseReferenceLabel.text)! + (sender.titleLabel?.text!)!
            }
        }
    }
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
        // if a text field is selected and has at least 1 char, delete last char
        if (verseReferenceLabel.text?.count)! > 0 {
            verseReferenceLabel.text? = ""
        }
    }
    
    @IBAction func newlineBtnTapped(_ sender: Any) {
        self.delegate?.newlineButtonWasTapped()
    }
    
    @IBAction func submitBtnTapped(_ sender: UIButton) {
    
        let passageReference = bookLabel.text! + " " + verseReferenceLabel.text!
        print("Passage reference: \(passageReference)")
        print(verseNumsIncludedSwitch.isOn)
        
        getBiblePassage(passageReference: passageReference){ passage, error in
            
            if let passage = passage {
                self.delegate?.submitButtonWasTapped(passage: passage)
            }
            else {
                let errorMessage = "Error"
                self.delegate?.submitButtonWasTapped(passage: errorMessage)
            }
            
        }
    }
    
    // MARK: - JSON Parsing Method
    func getBiblePassage(passageReference: String, completionHandler: @escaping (String?, Error?) -> ()) {
        let parameters:[String:Any] = ["q": passageReference,
                                       "include-passage-references": "true",
                                       "include-verse-numbers": String(verseNumsIncludedSwitch.isOn),
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
                completionHandler(nil, error)
            }
        }
    }
}

// MARK: - Extensions
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
