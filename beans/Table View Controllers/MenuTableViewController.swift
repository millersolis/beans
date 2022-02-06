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
    
    var tableView: UITableView = UITableView()
    
    var dishes = [String]()
    
    let cellHeight: CGFloat = 200
    let marginFromTableEdge: CGFloat = 20
    let sectionSpacing: CGFloat = Constants.MenuTableView.sectionSpacing
    
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
            self.adjustHeight()
        }
        
        //print(currentMenu.dishes)
        
        
        print("CURRENT MENU ID " + currentMenu.id)
        print(dishes)
        
        //Auto-set the UITableViewCells height (requires iOS8+)
        tableView.rowHeight = self.cellHeight
        
        tableView.isScrollEnabled = false
        
        //self.tableView = UITableView(frame: CGRect(x: 0, y: 225, width: view.frame.size.width, height: 500))
        self.adjustHeight()
        
        self.registerTableViewCells()
        
        self.tableView.backgroundColor = .white
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()
        
    }
    
    private func registerTableViewCells() {
       
        self.tableView.register(UINib(nibName: "DishTableViewCell", bundle: nil), forCellReuseIdentifier: "DishTableViewCell")
    }
    
    private func adjustHeight() {
        self.tableView.frame = CGRect(x: marginFromTableEdge, y: 200, width: (view.frame.width) - (2 * marginFromTableEdge), height: CGFloat(self.dishes.count) * (cellHeight + sectionSpacing) + sectionSpacing)
        self.tableView.contentSize = CGSize(width: (view.frame.width) - (2 * marginFromTableEdge), height: CGFloat(self.dishes.count) * (cellHeight + sectionSpacing) + sectionSpacing)
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
        
        cell?.optionDescription.text = "Description"
        cell?.optionDescription.sizeToFit()
        
        return cell!
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        print("in section \(indexPath.section).")
    }
    
    // Row tapping animation
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)

        UIView.animate(withDuration: 0.1) {
            cell!.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            cell!.layer.shadowOpacity = 0.7
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)

        UIView.animate(withDuration: 0.4) {
            cell!.transform = .identity
            cell!.layer.shadowOpacity = 0.5
        }
    }
}
