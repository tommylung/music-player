//
//  SearchViewController.swift
//  music-player
//

import RxSwift
import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var disposeBag = DisposeBag()
    var vm = SearchViewModel()
    
    @IBOutlet weak var sbSearch: UISearchBar!
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var aivActivity: UIActivityIndicatorView!
    @IBOutlet weak var tvSearch: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.bindUI()
        self.fetchData()
    }
    
    // MARK: - Core
    
    private func initUI() {
        self.vm.arrTrack.removeAll()
        self.vm.arrPlayedTrack.removeAll()
        
        self.navigationItem.title = NSLocalizedString("search_title", comment: "")
        self.sbSearch.placeholder = NSLocalizedString("common_search", comment: "")
        self.lblNoRecord.text = NSLocalizedString("no_record", comment: "")
        self.lblNoRecord.isHidden = false
        self.aivActivity.isHidden = true
        self.tvSearch.isHidden = true
        self.tvSearch.register(SearchTableViewCell.self, forCellReuseIdentifier: String(describing: SearchTableViewCell.self))
    }
    
    private func bindUI() {
        self.vm.psLoading.subscribe(onNext: { [weak self] bLoading in
            guard self != nil else { return }
            bLoading ? self?.aivActivity.startAnimating() : self?.aivActivity.stopAnimating()
            self?.aivActivity.isHidden = !bLoading
        }).disposed(by: self.disposeBag)
        
        self.vm.psError.subscribe(onNext: { [weak self] error in
            guard self != nil else { return }
            print("Error: \(error)")
        }).disposed(by: self.disposeBag)
        
        self.vm.psSearchMusic.subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            
            self.vm.arrTrack = response.results
            self.lblNoRecord.isHidden = response.results.count > 0
            self.tvSearch.isHidden = !(response.results.count > 0)
            
            self.tvSearch.reloadData()
        }).disposed(by: self.disposeBag)
    }
    
    private func fetchData() {
        
    }
    
    // MARK: - UISearchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.lblNoRecord.isHidden = true
        self.tvSearch.isHidden = true
        self.vm.arrTrack.removeAll()
        self.tvSearch.reloadData()
        
        self.vm.searchMusic(term: self.sbSearch.text, offset: 20, limit: 20)
        
        self.sbSearch.resignFirstResponder()
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tvSearch.dequeueReusableCell(withIdentifier: String(describing: SearchTableViewCell.self), for: indexPath) as! SearchTableViewCell
        
        if self.vm.arrTrack.count > indexPath.row {
            let track = self.vm.arrTrack[indexPath.row] as Result
            cell.updateData(arkworkUrl: track.artworkUrl60, trackName: track.trackName, artistName: track.artistName)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.arrTrack.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tvSearch.deselectRow(at: indexPath, animated: true)
    }

}
