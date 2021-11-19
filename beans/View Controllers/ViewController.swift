//
//  ViewController.swift
//  beans
//
//  Created by Miller on 14/11/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        //Style buttons
        Utilities.styleFilledButton(loginButton)
        Utilities.styleHollowButton(signUpButton)
    }
}
