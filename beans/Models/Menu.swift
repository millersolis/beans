//
//  Menu.swift
//  beans
//
//  Created by Miller on 6/12/21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Dish: Codable {
    var name: String
    var non_vegan: Option
    var vegan: Option
    
    enum CodingKeys: String, CodingKey {
        case name
        case non_vegan = "non-vegan"
        case vegan
    }
}

struct Option: Codable {
    var description: String
    var protein: String
    var carbs: String
    var veggies: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case protein
        case carbs
        case veggies
    }
}

struct MenuInDatabase: Codable {
    var dishes: [Dish]
    
    enum CodingKeys: String, CodingKey {
        case dishes
    }
}

class Menu {
    
    
    var id: String  //Date of the beggining of the week
    var dishes: [Dish]
    
    
    init(id: String) {
        self.id = id
        self.dishes = [Dish]()
        
        //startManagerObservation()
    }
    
    func fetchDishes(completion: @escaping (Bool) -> Void) {
        //Reference to db
        let db = Firestore.firestore()
        let requestedMenu = db.collection("menu").document(self.id)
        
        //Read data inside menu document
        requestedMenu.addSnapshotListener { (document, error) in

            if let document = document, document.exists {
                
                do{
                    //let menu = try document.data(as: MenuInDatabase.self)
                    self.dishes = try document.data(as: MenuInDatabase.self)!.dishes
                    //print(self.dishes)
                    completion(true)
                    return
                    
                    
                }
                catch{
                    print("FAILED PARSING MENU")
                    completion(false)
                    return
                }
                
            } else {
                print("Document does not exist")
                completion(false)
                return
            }
        }
    }

}
