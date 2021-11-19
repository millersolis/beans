//
//  SignUpViewController.swift
//  beans
//
//  Created by Miller on 14/11/21.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        //Hide error label
        errorLabel.alpha = 0
        
        //Style text fields
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        
        //Style button
        Utilities.styleFilledButton(signUpButton)
    }
    
    //Check fields and validate if data is correct.
    //Iff everything is correct, return nil.
    //Else return an error message.
    func ValidateFields() -> String? {
        //Text fields contents
        let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Check all fields are not empty
        if  firstName == "" || lastName == "" || email == "" || password == "" {
            return "Please fil in all fields"
        }
        
        //Check if password is secure
        if !Utilities.isPasswordValid(password!) {
            return "Please make sure your password is at least 8 characters long, contains a number and a special character"
        }

        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        //Validate fields
        let error = ValidateFields()
        
        if error != nil {
            //Show error message
            showError(error!)
        }
        else {
            //Create string user info
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create user
            Auth.auth().createUser(withEmail: email, password: password) { result, err in
                //Check for errors
                if err != nil {
                    //err?.localizedDescription //More detailed error description
                    self.showError("Error creating user")
                }
                else {
                    //User was created successfully, now store user data
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstName": firstName,
                                                              "lastName": lastName,
                                                              "uid": result!.user.uid]) { (error) in
                        if error != nil {
                            //Show error message
                            self.showError("Error saving user data")
                        }
                    }
                }
            }
             
            //Transition to home screen
            self.transitionToHome()
        }
    }
    
    //Show error message label with passed text
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    //Transition to home after user creation
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }

}
