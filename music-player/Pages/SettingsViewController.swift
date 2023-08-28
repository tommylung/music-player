//
//  SettingsViewController.swift
//  music-player
//

import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var tbvTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.bindUI()
        self.fetchData()
    }
    
    // MARK: - Core
    
    private func initUI() {
        self.navigationItem.title = NSLocalizedString("settings_title", comment: "")
    }
    
    private func bindUI() {
        
    }
    
    private func fetchData() {
        
    }
    
    // MARK: - UITableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let languageCell = UITableViewCell()
            languageCell.textLabel?.text = NSLocalizedString("language_settings", comment: "")
            languageCell.accessoryType = .disclosureIndicator
            return languageCell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        
        self.tbvTable.deselectRow(at: indexPath, animated: true)
    }
}
