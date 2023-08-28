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
        self.viewControllers?[0].tabBarItem.title = NSLocalizedString("home_title", comment: "")
        self.viewControllers?[1].tabBarItem.title = NSLocalizedString("search_title", comment: "")
        self.viewControllers?[2].tabBarItem.title = NSLocalizedString("settings_title", comment: "")
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
