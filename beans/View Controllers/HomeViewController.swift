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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidLayoutSubviews() {
        let welcome = UILabel(frame: CGRect(x: (view.frame.size.width/2) - 80, y: 80, width: 160, height: 40))
        welcome.text = Auth.auth().currentUser?.email //current user email
        
        /*let db = Firestore.firestore()
        let userData = db.collection("users").document(String(Auth.auth().currentUser!.uid))
        
        userData.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                let data = document.data()
                print("Document data: \(dataDescription)")
                welcome.text = String(data!["firstName"])
            } else {
                print("Document does not exist")
            }
        }*/
        
        welcome.textColor = .black
        welcome.adjustsFontSizeToFitWidth = true
        view.addSubview(welcome)
    }

}
