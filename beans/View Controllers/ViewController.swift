//
//  ViewController.swift
//  beans
//
//  Created by Miller on 14/11/21.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    var loginButton: UIButton!
    var signUpButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { auth, user in
          if user != nil {
              self.transitionToHome()
          } else {
            // No User is signed in. Show user the login screen
          }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .lightGray   //for debugging purposes
        
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
        //setUpElements()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setUpElements()
        
        setUpFloatingButtons()
        
    }
    
    @objc func loginTapped(sender: UIButton!) {
        self.transitionToLogin()
    }
    
    @objc func signUpTapped(sender: UIButton!) {
        self.transitionToSignUp()
    }
    
    func transitionToLogin() {
        let loginViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.loginViewController) as? LoginViewController
        
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }
    
    
    func transitionToSignUp() {
        let signUpViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.signUpViewController) as? SignUpViewController
        
        view.window?.rootViewController = signUpViewController
        view.window?.makeKeyAndVisible()
    }
    
    //Transition to home when there is a user logged in
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    func setUpElements() {
        let scrollView = UIScrollView(frame: view.bounds) //Flush to the sides

        scrollView.backgroundColor = .white
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 2100)
        view.addSubview(scrollView)
        
        let welcome = UILabel(frame: CGRect(x: (view.frame.size.width/2) - 80, y: 30, width: 160, height: 40))
        welcome.text = "Welcome to beans"
        welcome.textColor = .black
        scrollView.addSubview(welcome)
        
        let menuTitle = UILabel(frame: CGRect(x: (view.frame.size.width/2) - 50, y: 80, width: 100, height: 30))
        menuTitle.text = "Customize your meals"
        menuTitle.textColor = .black
        scrollView.addSubview(menuTitle)
        
        let menuEnd = UILabel(frame: CGRect(x: (view.frame.size.width/2) - 50, y: 2000, width: 100, height: 30))
        menuEnd.text = "This week's menu"
        menuEnd.textColor = .black
        scrollView.addSubview(menuEnd)
    }
    
    func setUpFloatingButtons() {
        //Floating buttons
        loginButton = UIButton(frame: CGRect(x: (view.frame.size.width/2) + 20, y: (view.frame.size.height) - 75, width: (view.frame.size.width/2) - 40, height: 50))
        loginButton.setTitle("Log In", for: .normal)
        Utilities.styleFilledButton(loginButton)
        loginButton.layer.masksToBounds = true
        view.addSubview(loginButton)
        view.bringSubviewToFront(loginButton)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        signUpButton = UIButton(frame: CGRect(x: 20, y: (view.frame.size.height) - 75, width: (view.frame.size.width/2) - 40, height: 50))
        signUpButton.setTitle("Sign Up", for: .normal)
        Utilities.styleHollowButton(signUpButton)
        signUpButton.layer.masksToBounds = true
        view.addSubview(signUpButton)
        view.bringSubviewToFront(signUpButton)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    }
}
