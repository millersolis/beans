//
//  Constants.swift
//  beans
//
//  Created by Miller on 17/11/21.
//

import Foundation
import UIKit

struct Constants {
    
    struct Storyboard {
        static let mainViewController = "MainViewController"
        static let homeViewController = "HomeViewController"
        static let loginViewController = "LoginViewController"
        static let signUpViewController = "SignUpViewController"
    }
    
    struct Colors {
        static let green = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        static let yellow = type(of: UIColor(hue: 48/360, saturation: 43/100, brightness: 100/100, alpha: 1.0)).init(red: 255/255, green: 233/255, blue: 145/255, alpha: 1.0)
    }
}
