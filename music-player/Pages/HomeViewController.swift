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
        self.navigationItem.title = NSLocalizedString("home_title", comment: "")
    }
    
    private func bindUI() {
        
    }
    
    private func fetchData() {
        
    }
}

