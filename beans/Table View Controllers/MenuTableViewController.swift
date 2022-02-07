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
    
    var desiredMenuId: String?
    var dishes = [Dish]()
    var dishNames = [String]()
    var chosenOption: String = Options.non_vegan.rawValue
    
    let cellHeight: CGFloat = 200
    let marginFromTableEdge: CGFloat = 20
    let sectionSpacing: CGFloat = Constants.MenuTableView.sectionSpacing
    
    
    /*convenience init() {
           self.init(imageURL: nil)
    }*/

    init(desiredMenuId: String) {
        self.desiredMenuId = desiredMenuId
        super.init(nibName: nil, bundle: nil)
    }

    // if this view controller is loaded from a storyboard, imageURL will be nil

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    enum Options: String{
        case non_vegan = "Non-vegan"
        case vegan = "Vegan"
    }
    
    enum SelectOption{
        case non_vegan
        case vegan
    }
    
    func selectOption(_ option:SelectOption){
        switch option{
        case .non_vegan:
            self.chosenOption = Options.non_vegan.rawValue
            self.tableView.reloadData()
        case .vegan:
            self.chosenOption = Options.vegan.rawValue
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let desiredMenu = Menu(id: desiredMenuId ?? "") // TODO: Make logic for no Id provided
        
        desiredMenu.fetchDishes { success in
            print(success)
            if success {
                self.dishes = desiredMenu.dishes
                
                for dish in desiredMenu.dishes {
                    self.dishNames.append(dish.name)
                    print(dish.name)
                }
                
                self.tableView.reloadData()
                self.adjustTableSize()
            }
            else {
                self.showToast(message: "Could not load menu", font: UIFont.boldSystemFont(ofSize: 15))
            }
        }
        
        //print(currentMenu.dishes)
        
        
        print("CURRENT MENU ID " + desiredMenu.id)
        print(dishNames)
        
        //Auto-set the UITableViewCells height (requires iOS8+)
        tableView.rowHeight = self.cellHeight
        tableView.isScrollEnabled = false
        
        self.adjustTableSize()
        self.registerTableViewCells()
        
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func registerTableViewCells() {
       
        self.tableView.register(UINib(nibName: "DishTableViewCell", bundle: nil), forCellReuseIdentifier: "DishTableViewCell")
    }
    
    private func adjustTableSize() {
        self.tableView.frame = CGRect(x: marginFromTableEdge, y: 200, width: (view.frame.width) - (2 * marginFromTableEdge), height: CGFloat(self.dishNames.count) * (cellHeight + sectionSpacing) + sectionSpacing)
        self.tableView.contentSize = CGSize(width: (view.frame.width) - (2 * marginFromTableEdge), height: CGFloat(self.dishNames.count) * (cellHeight + sectionSpacing) + sectionSpacing)
    }
    
    func showToast(message: String, font: UIFont) {
        let screenSize = UIScreen.main.bounds
        
        let toastLabel = UILabel(frame: CGRect(x: screenSize.width/2 - 100, y: screenSize.height - 80, width: 200, height: 50))
        
        toastLabel.backgroundColor = Constants.Colors.yellow.withAlphaComponent(1.0)
        toastLabel.textColor = .darkGray
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 25
        toastLabel.clipsToBounds = true
        
        self.tableView.superview?.addSubview(toastLabel)
        UIView.animate(withDuration:4, delay:0.5, options:[], animations: {
                toastLabel.alpha = 0.0;
            }) { (Bool) in
                    toastLabel.removeFromSuperview();
            }
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
        
        cell?.dishName.text = self.dishes[indexPath.section].name
        cell?.dishName.sizeToFit()
        
        cell?.option.text = self.chosenOption
        cell?.option.sizeToFit()
        
        switch self.chosenOption{
            case Options.non_vegan.rawValue:
                cell?.optionDescription.text = self.dishes[indexPath.section].non_vegan.description
            case Options.vegan.rawValue:
                cell?.optionDescription.text = self.dishes[indexPath.section].vegan.description
            default:
                cell?.optionDescription.text = self.dishes[indexPath.section].non_vegan.description
        }
        cell?.optionDescription.sizeToFit()
        
        // TODO: Set images
        // cell?.picture.image = UIImage(named: "default_image.JPEG")
        
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
