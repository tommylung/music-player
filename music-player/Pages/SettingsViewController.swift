//
//  SettingsViewController.swift
//  music-player
//

import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var tvTable: UITableView!
    
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
            let alert = UIAlertController(title: NSLocalizedString("change_language_title", comment: ""), message: NSLocalizedString("change_language_message", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("common_go_to_settings", comment: ""), style: .default, handler: { _ in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("common_cancel", comment: ""), style: .destructive))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        self.tvTable.deselectRow(at: indexPath, animated: true)
    }
}
