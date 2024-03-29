//
//  LoginViewController.swift
//  beans
//
//  Created by Miller on 14/11/21.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var backButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        view.backgroundColor = .white
        
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
        setUpElements()
    }
    
    func setUpElements() {
        //Hide error label
        errorLabel.alpha = 0
        
        //Style text fields
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        
        //Style buttons
        Utilities.styleFilledButton(loginButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //Back button
        backButton = UIButton(frame: CGRect(x: 25, y: 45, width: 30, height: 30))
        backButton.setImage(UIImage(systemName: "arrowshape.turn.up.backward.fill"), for: .normal)
        backButton.tintColor = Constants.Colors.green
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        //Validate text fields
        //TODO: check non-empty
        
        //Create string user info
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Sign in user
        Auth.auth().signIn(withEmail: email, password: password) { result, err in
            //Check for errors
            if err != nil {
                self.showError(err!.localizedDescription) //More detailed error description
                //self.showError("Error logging in")
            }
            else {
                //User was logged in successfully
                self.transitionToHome()
            }
        }
    }
    
    //Go back to main when back button tapped
    @objc func backTapped(sender: UIButton!) {
        transitionToMain()
    }
    
    //Show error message label with passed text
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    //Transition to home after signing in
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    //Transition to main screen
    func transitionToMain() {
        let mainViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mainViewController) as? ViewController
        
        view.window?.rootViewController = mainViewController
        view.window?.makeKeyAndVisible()
    }
    
}
