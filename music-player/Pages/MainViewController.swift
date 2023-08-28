//
//  MainViewController.swift
//  music-player
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func awakeFromNib() {
        if let item = self.viewControllers?[0].tabBarItem {
            item.title = NSLocalizedString("home_title", comment: "")
            item.image = UIImage(named: "HomeNavigationNonActiveIcon")
            item.selectedImage = UIImage(named: "HomeNavigationActiveIcon")
        }
        if let item = self.viewControllers?[1].tabBarItem {
            item.title = NSLocalizedString("search_title", comment: "")
            item.image = UIImage(named: "SearchNavigationIcon")
        }
        if let item = self.viewControllers?[2].tabBarItem {
            item.title = NSLocalizedString("settings_title", comment: "")
            item.image = UIImage(named: "SettingsNavigationNonActiveIcon")
            item.selectedImage = UIImage(named: "SettingsNavigationActiveIcon")
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
    
    
}
