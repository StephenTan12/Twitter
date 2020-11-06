//
//  TweetViewController.swift
//  Twitter
//
//  Created by Stephen Tan on 11/4/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(TweetViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TweetViewController.keyboardWillShow), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tweetTextView.delegate = self
        //display keyboard on segue
        tweetTextView.becomeFirstResponder()
        characterCountLabel.text = "0/280"
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        // getting the information on the size of the keyboard
        guard let userInfo = notification.userInfo else {return}
        
        // getting the size of the keyboard
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        let keyboardFrame = keyboardSize.cgRectValue
        
        // updating the height of the screen
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // getting the information on the size of the keyboard
        guard let userInfo = notification.userInfo else {return}
               
        // getting the size of the keyboard
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
               
        let keyboardFrame = keyboardSize.cgRectValue
        
        // setting origin.y back to 0
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += keyboardFrame.height
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // set max character limit
        let characterLimit = 280
        
        // determine what the new text should be adter the user's lastest edit
        let newText = NSString(string: tweetTextView.text!).replacingCharacters(in: range, with: text)
        
        characterCountLabel.text = "\(newText.count)/\(characterLimit)"
        
        // determine whether if the new text is beyond the limit
        return newText.count < characterLimit
    }

    @IBAction func cancelTweet(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweet(_ sender: Any) {
        if (!tweetTextView.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (Error) in
                print("Error posting tweet: \(Error)")
                self.dismiss(animated: true, completion: nil)
            })
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
