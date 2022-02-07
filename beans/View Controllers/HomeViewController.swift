//
//  HomeViewController.swift
//  beans
//
//  Created by Miller on 14/11/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestoreSwift


class HomeViewController: UIViewController {
    
    var logoutButton: UIButton!
    var optionControl: UISegmentedControl!
    var scrollView: UIScrollView!
    var welcome: UILabel!
    
    var menuTableController: MenuTableViewController!
    
    let sectionSpacing: CGFloat = Constants.MenuTableView.sectionSpacing
    

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
        
        let currentMenuId = "6-12-2021"
        
        menuTableController = MenuTableViewController(desiredMenuId: currentMenuId)
        
        
        //Scroll view setup
        scrollView = UIScrollView(frame: view.bounds) //Flush to the sides
        scrollView.backgroundColor = .white
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: menuTableController.tableView.frame.height + 200)
        view.addSubview(scrollView)
        
        self.setupOptionController()
                
        
        //Embed tableView as subview
        embed(viewController: menuTableController, frame: CGRect(x: 0, y: 200, width: view.frame.size.width, height: menuTableController.tableView.frame.height))
        
        
        //Welcome label setup
        welcome = UILabel(frame: CGRect(x: 0, y: 60, width: scrollView.frame.width, height: 50))
        //welcome.text = Auth.auth().currentUser?.email //current user email
        
        
        let db = Firestore.firestore()
        let userData = db.collection("users").document(String(Auth.auth().currentUser!.uid))

        // TODO: Grab from cached data if possible
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
        
        // TODO: Align all text in the middle of label
        welcome.textColor = Constants.Colors.green
        welcome.font = UIFont.boldSystemFont(ofSize: 25)
        welcome.textAlignment = .center
        scrollView.addSubview(welcome)
        
        
        //logout button setup
        logoutButton = UIButton(frame: CGRect(x: view.frame.size.width - 80, y: 30, width: 80, height: 25))
        logoutButton.setTitle("Logout", for: .normal)
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
    
    func setupOptionController() {
        optionControl = UISegmentedControl(items: [MenuTableViewController.Options.non_vegan.rawValue, MenuTableViewController.Options.vegan.rawValue])
        
        optionControl.addTarget(self, action: #selector(selectOption(_:)), for: .valueChanged)
        
        optionControl.selectedSegmentIndex = 0
        menuTableController.selectOption(MenuTableViewController.SelectOption.non_vegan)
        
        optionControl.frame = CGRect(x: scrollView.frame.width/2 - 80, y: 120, width: 160, height: 40)
        
        optionControl.layer.cornerRadius = 40.0
        optionControl.backgroundColor = Constants.Colors.green
        optionControl.selectedSegmentTintColor = .white
        
        scrollView.addSubview(optionControl)
    }
    
    @objc func selectOption(_ segmentedControl: UISegmentedControl) {
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            menuTableController.selectOption(MenuTableViewController.SelectOption.non_vegan)
            print("Show non-veg")
        case 1:
            menuTableController.selectOption(MenuTableViewController.SelectOption.vegan)
            print("Show veg")
        default:
            menuTableController.selectOption(MenuTableViewController.SelectOption.non_vegan)
            print("Show non-veg")
        }
    }
}
