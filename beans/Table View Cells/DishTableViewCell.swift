//
//  DishTableViewCell.swift
//  beans
//
//  Created by Miller on 5/12/21.
//

import UIKit


class DishTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dishName: UILabel!
    
    @IBOutlet weak var option: UILabel!
    
    @IBOutlet weak var optionDescription: UILabel!
    
    @IBOutlet weak var picture: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.styleCell()
        
    }
    
    private func styleCell() {
        // Content
        self.styleCellContent()
        
        // Cell
        self.backgroundColor = Constants.Colors.yellow
        self.layer.borderColor = Constants.Colors.green.cgColor
        self.layer.borderWidth = 5
        self.layer.cornerRadius = 15
        //self.clipsToBounds = true
        
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    private func styleCellContent() {
        self.dishName.font = UIFont.boldSystemFont(ofSize: 20)
        self.dishName.textAlignment = .left
        
        self.option.font = UIFont.boldSystemFont(ofSize: 15)
        self.option.textColor = .systemGray2
        self.option.textAlignment = .left
        
        self.optionDescription.textColor = .darkGray
        self.optionDescription.textAlignment = .left
        // TODO test
        self.optionDescription.lineBreakMode = .byWordWrapping
        
        
        // Placeholders
        self.dishName.text = "Name"
        self.option.text = "Option"
        self.optionDescription.text = "Description"
        self.picture.image = UIImage(named: "default_image.JPEG")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
