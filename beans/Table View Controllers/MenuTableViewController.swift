//
//  MenuTableViewController.swift
//  beans
//
//  Created by Miller on 2/12/21.
//

import SwiftUI
import UIKit

// TODO: Make UITableViewController

class MenuTableViewController: UIViewController{
    
    //@ObservedObject var model = MenuViewModel()
    
    //let dishes: [String] = ["Poke bowl", "Peri-peri special", "Kangaroo from 2014", "Lemon garlic special", "beans special"]
    
    let sectionSpacing: CGFloat = Constants.MenuTableView.sectionSpacing
    let cellReuseIdentifier = "cell"
    
    var tableView: UITableView = UITableView()
    
    var dishes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let currentMenu = Menu(id: "6-12-2021")
        currentMenu.fetchDishes { success in
            print(success)
            self.dishes = [String]()
            for dish in currentMenu.dishes {
                self.dishes.append(dish.name)
                print(dish.name)
            }
            self.tableView.reloadData()
        }
        
        //print(currentMenu.dishes)
        
       
        
        print("CURRENT MENU ID " + currentMenu.id)
        print(dishes)
        
        //Auto-set the UITableViewCells height (requires iOS8+)
        tableView.rowHeight = 286
        
        tableView.isScrollEnabled = false
        
        //self.tableView = UITableView(frame: CGRect(x: 0, y: 225, width: view.frame.size.width, height: 500))
        self.tableView.frame = CGRect(x: sectionSpacing, y: 150, width: (view.frame.width) - 20, height: 286 * 5 + sectionSpacing * 5)
        self.tableView.contentSize = CGSize(width: (view.frame.width) - 20, height: 286 * 5  + sectionSpacing * 5)
        
        self.registerTableViewCells()
        
        self.tableView.backgroundColor = .white
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()
        
    }
    
    private func registerTableViewCells() {
        //let textFieldCell = UINib(nibName: "DishTableViewCell", bundle: nil)
        //self.tableView.register(textFieldCell, forCellReuseIdentifier: "DishTableViewCell")
        self.tableView.register(UINib(nibName: "DishTableViewCell", bundle: nil), forCellReuseIdentifier: "DishTableViewCell")
    }
    
}

extension MenuTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dishes.count
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionSpacing
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DishTableViewCell") as? DishTableViewCell
        
        cell?.dishName.text = self.dishes[indexPath.section]
        cell?.dishName.sizeToFit()
        
        cell?.description1.text = "Description for option 1"
        cell?.description1.sizeToFit()
        
        cell?.description2.text = "Description for option 2"
        cell?.description2.sizeToFit()
        
        
        /*if let cell = self.tableView.dequeueReusableCell(withIdentifier: "DishTableViewCell") as? DishTableViewCell {
            // set the text from the data model
            //cell.textLabel?.text = self.dishes[indexPath.section]
            
            
            
            return cell
        }
        
        //return UITableViewCell()*/
        
        return cell!
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        print("in section \(indexPath.section).")
    }

}
