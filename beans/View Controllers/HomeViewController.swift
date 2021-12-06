//
//  HomeViewController.swift
//  beans
//
//  Created by Miller on 14/11/21.
//

import UIKit
import FirebaseAuth
import Firebase


class HomeViewController: UIViewController {
    
    var logoutButton: UIButton!
    var scrollView: UIScrollView!
    var welcome: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
    }
    

    /*
    // TODO: 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //Scroll view setup
        self.scrollView = UIScrollView(frame: view.bounds) //Flush to the sides
        self.scrollView.backgroundColor = .white
        self.scrollView.contentSize = CGSize(width: view.frame.size.width, height: 2100)
        view.addSubview(scrollView)
                
        
        //Embed tableView as subview
        let menuTableController = MenuTableViewController()
        embed(viewController: menuTableController, frame: CGRect(x: 0, y: 225, width: view.frame.size.width, height: 500))
        
        
        //Welcome label setup
        self.welcome = UILabel(frame: CGRect(x: (view.frame.size.width/2) - 80, y: 80, width: 300, height: 100))
        //welcome.text = Auth.auth().currentUser?.email //current user email
        
        
        let db = Firestore.firestore()
        let userData = db.collection("users").document(String(Auth.auth().currentUser!.uid))

        
        userData.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                //let data = document.data()
                print("Document data: \(dataDescription)")
                self.welcome.text = "Welcome back " + (document["firstName"] as? String ?? "nil")
            } else {
                print("Document does not exist")
            }
        }
        //TODO: Create model and model listener

        //TODO: UI design
        //TODO: Figma??
        welcome.textColor = Constants.Colors.green
        welcome.minimumScaleFactor = 1.5
        welcome.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(welcome)
        
        
        //logout button setup
        logoutButton = UIButton(frame: CGRect(x: (view.frame.size.width/2) + 20, y: (view.frame.size.height) - 75, width: (view.frame.size.width/2) - 40, height: 50))
        logoutButton.setTitle("Logout", for: .normal)
        //Utilities.styleFilledButton(logout)
        logoutButton.setTitleColor(.red, for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        scrollView.addSubview(logoutButton)
    }
    
    @objc func logoutTapped(sender: UIButton!) {
        self.logoutUser()
        self.transitionToMain()
    }
    
    func logoutUser() {
        do{
            try Auth.auth().signOut()
        } catch let logoutError {
            self.showError(logoutError.localizedDescription)
        }
    }
    
    //Transition to main screen after logout
    func transitionToMain() {
        let mainViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.mainViewController) as? ViewController
        
        view.window?.rootViewController = mainViewController
        view.window?.makeKeyAndVisible()
    }

    //Show error message label with passed text
    func showError(_ message: String) {
        //TODO: Mofidy accourding to revised UI
        logoutButton.setTitle(message, for: .normal)
    }
    
    func embed(viewController: MenuTableViewController, frame: CGRect? = nil) {
            
            addChild(viewController)
            scrollView.addSubview(viewController.tableView)
            viewController.view.frame = view.bounds
            viewController.didMove(toParent: self)
    }
}
