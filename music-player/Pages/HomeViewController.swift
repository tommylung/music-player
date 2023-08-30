//
//  HomeViewController.swift
//  music-player
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var vm = HomeViewModel()
    var vcPlay: PlayerViewController?
    
    @IBOutlet weak var tvTrack: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.bindUI()
        self.fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshFavourite()
    }
    
    //MARK: - Core
    
    private func initUI() {
        // Greeting
        let currentHour = Calendar.current.component(.hour, from: Date())
        if currentHour >= 0 && currentHour < 12 {
            self.navigationItem.title = NSLocalizedString("home_goodmorning", comment: "")
        } else if currentHour >= 12 && currentHour < 18 {
            self.navigationItem.title = NSLocalizedString("home_goodafternoon", comment: "")
        } else {
            self.navigationItem.title = NSLocalizedString("home_goodnight", comment: "")
        }
        
        self.tvTrack.register(SearchTableViewCell.self, forCellReuseIdentifier: String(describing: SearchTableViewCell.self))
    }
    
    private func bindUI() {
        self.vm.psSearchMusic1.subscribe(onNext: { strArtist, response in
            self.vm.arrArtist.append(strArtist)
            self.vm.dictTrack[strArtist] = response.results
            self.tvTrack.reloadData()
        }).disposed(by: self.vm.disposeBag)
        
        self.vm.psSearchMusic2.subscribe(onNext: { strArtist, response in
            self.vm.arrArtist.append(strArtist)
            self.vm.dictTrack[strArtist] = response.results
            self.tvTrack.reloadData()
        }).disposed(by: self.vm.disposeBag)
        
        self.vm.psSearchMusic3.subscribe(onNext: { strArtist, response in
            self.vm.arrArtist.append(strArtist)
            self.vm.dictTrack[strArtist] = response.results
            self.tvTrack.reloadData()
        }).disposed(by: self.vm.disposeBag)
    }
    
    private func fetchData() {
        // Get 3 artists songs
        self.vm.searchMusic(term: NSLocalizedString("home_song1", comment: ""), number: 1)
        self.vm.searchMusic(term: NSLocalizedString("home_song2", comment: ""), number: 2)
        self.vm.searchMusic(term: NSLocalizedString("home_song3", comment: ""), number: 3)
    }
    
    private func refreshFavourite() {
        self.vm.arrFavourite = TrackManager.shared.getFavourite()
        self.tvTrack.reloadData()
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // +1 for favourite at section 0
        return self.vm.dictTrack.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Section 0 for favourite
        if section == 0 {
            return self.vm.arrFavourite.count
        }
        
        for (index, key) in self.vm.dictTrack.enumerated() {
            if index == section - 1 {
                return key.value.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            // Section 0 for favourite
            return NSLocalizedString("home_favourite", comment: "")
        } else {
            return self.vm.arrArtist[section - 1]
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tvTrack.dequeueReusableCell(withIdentifier: String(describing: SearchTableViewCell.self), for: indexPath) as! SearchTableViewCell
        
        if indexPath.section != 0 {
            if let tracks = self.vm.dictTrack[self.vm.arrArtist[indexPath.section - 1]] as [Result]?, tracks.count != 0 {
                let track = tracks[indexPath.row]
                cell.updateData(arkworkUrl: track.artworkUrl60, trackName: track.trackName, artistName: track.artistName)
            }
        } else {
            let track = self.vm.arrFavourite[indexPath.row]
            cell.updateData(arkworkUrl: track.artworkUrl60, trackName: track.trackName, artistName: track.artistName)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tvTrack.deselectRow(at: indexPath, animated: true)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Search", bundle:nil)
        self.vcPlay = storyBoard.instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController
        if let vcPlay = self.vcPlay {
            // Refresh favourite list if click the player on home page
            // We used RxSwift PS to subscribe the dismiss callback trigger
            // Because it cannot call the viewDidAppear or viewWillAppear by modal presentation
            vcPlay.vm.psDismiss.subscribe(onNext: {
                self.refreshFavourite()
            }).disposed(by: self.vm.disposeBag)
            
            // Get the track infomation to player
            if indexPath.section != 0 {
                if let tracks = self.vm.dictTrack[self.vm.arrArtist[indexPath.section - 1]] as [Result]? {
                    vcPlay.vm.track = tracks[indexPath.row]
                }
            } else {
                vcPlay.vm.track = self.vm.arrFavourite[indexPath.row]
            }
            
            self.navigationController?.present(vcPlay, animated: true)
        }
    }
}

