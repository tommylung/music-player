//
//  SearchViewController.swift
//  music-player
//

import RxSwift
import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var disposeBag = DisposeBag()
    var vm = SearchViewModel()
    
    @IBOutlet weak var scMedia: UISegmentedControl!
    @IBOutlet weak var scCountry: UISegmentedControl!
    @IBOutlet weak var sbSearch: UISearchBar!
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var btnSearchAgain: UIButton!
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
        self.vm.iCurrentPage = 1
        
        self.navigationItem.title = NSLocalizedString("search_title", comment: "")
        self.sbSearch.placeholder = NSLocalizedString("common_search", comment: "")
        self.lblNoRecord.text = NSLocalizedString("search_no_record", comment: "")
        self.lblResult.isHidden = true
        self.lblResult.text = nil
        self.btnSearchAgain.setTitle(NSLocalizedString("saerch_search_again", comment: ""), for: .normal)
        
        self.scMedia.removeAllSegments()
        for mediaType in Enum.MediaType.allCases {
            self.scMedia.insertSegment(withTitle: NSLocalizedString(mediaType.localizationString, comment: "") , at: Enum.MediaType.allCases.count, animated: false)
        }
        self.scMedia.selectedSegmentIndex = 0
        self.scCountry.removeAllSegments()
        for country in Enum.Country.allCases {
            self.scCountry.insertSegment(withTitle: NSLocalizedString(country.localizationString, comment: "") , at: Enum.Country.allCases.count, animated: false)
        }
        self.scCountry.selectedSegmentIndex = 0
        
        self.lblNoRecord.isHidden = false
        self.btnSearchAgain.isHidden = true
        self.aivActivity.isHidden = true
        self.tvSearch.isHidden = true
        self.tvSearch.register(SearchTableViewCell.self, forCellReuseIdentifier: String(describing: SearchTableViewCell.self))
    }
    
    private func bindUI() {
        self.vm.psLoading.subscribe(onNext: { [weak self] bLoading in
            guard let self = self else { return }
            
            bLoading ? self.aivActivity.startAnimating() : self.aivActivity.stopAnimating()
            self.aivActivity.isHidden = !bLoading
            self.btnSearchAgain.isHidden = true
        }).disposed(by: self.disposeBag)
        
        self.vm.psError.subscribe(onNext: { [weak self] error in
            guard let self = self else { return }
            
            print("Error: \(error)")
            
            self.lblResult.isHidden = true
            self.lblNoRecord.text = NSLocalizedString("search_error", comment: "")
            self.lblNoRecord.isHidden = false
            self.btnSearchAgain.isHidden = false
            self.tvSearch.isHidden = true
        }).disposed(by: self.disposeBag)
        
        self.vm.psSearchMusic.subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            
            // Set boolean to check the pagination
            // Prevent to call next page if there is no extra tracks
            if (response.resultCount < self.vm.iTrackPerPage) {
                self.vm.bEnd = true
            }
            self.vm.arrTrack.append(contentsOf: response.results)
            
            self.lblResult.text = String(format: (NSLocalizedString("search_result", comment: "") as NSString) as String, self.vm.arrTrack.count)
            self.lblResult.isHidden = !(self.vm.arrTrack.count > 0)
            self.lblNoRecord.text = NSLocalizedString("search_no_record", comment: "")
            self.lblNoRecord.isHidden = self.vm.arrTrack.count > 0
            self.btnSearchAgain.isHidden = true
            self.tvSearch.isHidden = !(self.vm.arrTrack.count > 0)
            
            self.tvSearch.reloadData()
        }).disposed(by: self.disposeBag)
    }
    
    private func fetchData() {
        
    }
    
    private func updateUI(initSearch: Bool = false) {
        self.lblNoRecord.isHidden = true
        self.btnSearchAgain.isHidden = true
        self.tvSearch.isHidden = true
        if (initSearch) {
            self.lblResult.isHidden = true
            self.vm.arrTrack.removeAll()
            self.vm.iCurrentPage = 1
        }
        self.tvSearch.reloadData()
    }
    
    private func search() {
        self.vm.searchMusic(term: self.sbSearch.text ?? "",
                            media: Enum.MediaType.allCases[self.scMedia.selectedSegmentIndex].rawValue,
                            country: Enum.Country.allCases[self.scCountry.selectedSegmentIndex].code)
    }
    
    // MARK: - UISegmentedControl
    
    @IBAction func segmentedValueChanged(_ sender: Any) {
        // Clear all tracks
        // Search all track again if segmented controller value changed
        self.vm.arrTrack.removeAll()
        self.vm.iCurrentPage = 1
        self.updateUI(initSearch: true)
        
        // Search it again
        self.search()
        
        self.sbSearch.resignFirstResponder()
    }
    
    
    // MARK: - UISearchBar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.updateUI(initSearch: true)
        
        self.search()
        
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
        
        // Preset to player
        let storyBoard : UIStoryboard = UIStoryboard(name: "Search", bundle:nil)
        let vcPlay = storyBoard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        vcPlay.vm.track = self.vm.arrTrack[indexPath.row]
        self.navigationController?.present(vcPlay, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Pagination
        // Call next page API if displayed the last item
        if (indexPath.row == self.vm.arrTrack.count - 1 && !self.vm.bEnd) {
            self.vm.iCurrentPage += 1
            self.search()
        }
    }
    
    // MARK: - Button
    
    @IBAction func btnSearchAgainOnClick(_ sender: Any) {
        // Clear all tracks
        self.vm.arrTrack.removeAll()
        self.vm.iCurrentPage = 1
        
        self.search()
        
        self.sbSearch.resignFirstResponder()
    }
}
