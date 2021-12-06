//
//  DishTableViewCell.swift
//  beans
//
//  Created by Miller on 5/12/21.
//

import UIKit



class DishTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var dishName: UILabel!
    
    @IBOutlet weak var option1: UILabel!
    @IBOutlet weak var description1: UILabel!
    
    @IBOutlet weak var option2: UILabel!
    @IBOutlet weak var description2: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.dishName.font = UIFont.boldSystemFont(ofSize: 20)
        
        self.option1.font = UIFont.boldSystemFont(ofSize: 18)
        self.option1.textColor = .darkGray
        self.option1.text = "Non-vegan"
        self.option1.sizeToFit()
        
        self.option2.font = UIFont.boldSystemFont(ofSize: 18)
        self.option2.textColor = .darkGray
        self.option2.text = "Vegan"
        self.option2.sizeToFit()
        
        self.description1.textColor = .systemGray2
        self.description2.textColor = .systemGray2
        
        
        
        self.backgroundColor = Constants.Colors.yellow

        self.layer.borderColor = Constants.Colors.green.cgColor
        self.layer.borderWidth = 5
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
