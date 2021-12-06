//
//  MenuTableViewController.swift
//  beans
//
//  Created by Miller on 2/12/21.
//

import UIKit

// TODO: Make UITableViewController

class MenuTableViewController: UIViewController {
    
    let dishes: [String] = ["Poke bowl", "Peri-peri special", "Kangaroo from 2014", "Lemon garlic special", "beans special"]
    let cellSpacingHeight: CGFloat = 5
    let cellReuseIdentifier = "cell"
    
    var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Auto-set the UITableViewCells height (requires iOS8+)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        //self.tableView = UITableView(frame: CGRect(x: 0, y: 225, width: view.frame.size.width, height: 500))
        self.tableView.frame = CGRect(x: 0, y: 250, width: view.frame.width, height: 500)
        self.tableView.contentSize = CGSize(width: view.frame.width, height: 500)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        self.tableView.backgroundColor = .white
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()

        
        
        
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
        cell.textLabel?.text = self.dishes[indexPath.section]
        
        cell.backgroundColor = Constants.Colors.yellow
        
        cell.layer.borderColor = Constants.Colors.green.cgColor
        cell.layer.borderWidth = 4
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}
