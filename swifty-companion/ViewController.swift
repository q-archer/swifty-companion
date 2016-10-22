//
//  ViewController.swift
//  swifty-companion
//
//  Created by Quentin ARCHER on 9/2/16.
//  Copyright © 2016 Quentin ARCHER. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK : Properties
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var SearchButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        loginTextField.delegate = self
    
        checkValidLogin()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    // MARK: segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let profilViewController = segue.destinationViewController as! ProfilViewController
        profilViewController.login = loginTextField.text
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        SearchButton.enabled = false
    }

    func checkValidLogin() {
        let text = loginTextField.text ?? ""
        SearchButton.enabled = !text.isEmpty
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidLogin()
    }
}

