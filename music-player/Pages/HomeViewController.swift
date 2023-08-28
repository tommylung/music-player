//
//  HomeViewController.swift
//  music-player
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.bindUI()
        self.fetchData()
    }
    
    //MARK: - Core
    
    private func initUI() {
        let currentHour = Calendar.current.component(.hour, from: Date())
        if (currentHour >= 0 && currentHour < 12) {
            self.navigationItem.title = NSLocalizedString("home_goodmorning", comment: "")
        } else if (currentHour >= 12 && currentHour < 18) {
            self.navigationItem.title = NSLocalizedString("home_goodafternoon", comment: "")
        } else {
            self.navigationItem.title = NSLocalizedString("home_goodnight", comment: "")
        }
    }
    
    private func bindUI() {
        
    }
    
    private func fetchData() {
        
    }
}

