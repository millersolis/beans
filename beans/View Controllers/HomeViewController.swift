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
    
    let cellReuseIdentifier = "cell"
    let dishes: [String] = ["Poke bowl", "Peri-peri special", "Kangaroo from 2014", "Lemon garlic special", "beans special"]
    var tableView: UITableView!
    let cellSpacingHeight: CGFloat = 5
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: 225, width: view.frame.size.width, height: view.frame.size.height))
        
        // Register the table view cell class and its reuse id
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
                
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        
        
        /*let dishOne = nextWeekCollection.dequeueReusableCell(withReuseIdentifier: "nextWeekMenuItem", for: IndexPath(row: 0, section: 0))
        
        dishOne.sizeThatFits(CGSize(width: view.frame.size.width - 20, height: view.frame.size.height - 20))
        dishOne.backgroundColor = .black*/
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let db = Firestore.firestore()
        let userData = db.collection("users").document(String(Auth.auth().currentUser!.uid))
        
        /*let scrollView = UIScrollView(frame: view.bounds) //Flush to the sides
        //let scrollView = UIScrollView(frame: CGRect(x: 10, y: 10, width: view.frame.size.width - 20, height: view.frame.size.height - 20))  //View backgorund color margins
        scrollView.backgroundColor = .white
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 2100)
        view.addSubview(scrollView)*/
        
        
        
        
        
        
        
        
        let welcome = UILabel(frame: CGRect(x: (view.frame.size.width/2) - 80, y: 80, width: 300, height: 100))
        //welcome.text = Auth.auth().currentUser?.email //current user email
        userData.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                //let data = document.data()
                print("Document data: \(dataDescription)")
                welcome.text = "Welcome back " + (document["firstName"] as? String ?? "nil")
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
        view.addSubview(welcome)
        
        
        
        //logout buttons
        logoutButton = UIButton(frame: CGRect(x: (view.frame.size.width/2) + 20, y: (view.frame.size.height) - 75, width: (view.frame.size.width/2) - 40, height: 50))
        logoutButton.setTitle("Logout", for: .normal)
        //Utilities.styleFilledButton(logout)
        logoutButton.setTitleColor(.red, for: .normal)
        view.addSubview(logoutButton)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
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
        logoutButton.setTitle(message, for: .normal)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dishes.count
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! //as? UITableViewCell   //WFT??
        
        // set the text from the data model
        cell.textLabel?.text = self.dishes[indexPath.row]
        
        cell.backgroundColor = Constants.Colors.yellow
        
        cell.layer.borderColor = Constants.Colors.green.cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}
