//
//  PlayerViewController.swift
//  music-player
//

import AVFoundation
import RxSwift
import UIKit

class PlayerViewController: UIViewController {

    var vm = PlayerViewModel()
    let player = AVQueuePlayer()
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgvArtwork: UIImageView!
    @IBOutlet weak var lblTrackName: UILabel!
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var pvProgressBar: UIProgressView!
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var btnSkipPrevious: UIButton!
    @IBOutlet weak var btnPlayAndPause: UIButton!
    @IBOutlet weak var btnSkipNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.bindUI()
        self.fetchData()
        self.updateUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.player.pause()
        self.vm.psDismiss.onNext(())
    }
    
    // MARK: - Core
    
    private func initUI() {
        self.imgvArtwork.image = nil
        self.lblTrackName.text = nil
        self.lblArtistName.text = nil
        self.pvProgressBar.progress = 0.0
        self.lblCurrentTime.text = self.secondToTime(seconds: 0)
        self.lblDuration.text = self.secondToTime(seconds: 0)
        self.btnPlayAndPause.setImage(UIImage(named: "Play"), for: .normal)
        self.btnSkipPrevious.isHidden = true
        self.btnSkipNext.isHidden = true
        
        self.player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main, using: { (time) in
            if self.player.currentItem?.status == .readyToPlay {
                if let currentItem = self.player.currentItem {
                    let duration = CMTimeGetSeconds(currentItem.duration)
                    let currentTime = CMTimeGetSeconds(currentItem.currentTime())
                    
                    self.lblDuration.text = self.secondToTime(seconds: duration)
                    self.lblCurrentTime.text = self.secondToTime(seconds: currentTime)
                    self.pvProgressBar.progress = Float(currentTime / duration)
                }
            }
        })
    }
    
    private func bindUI() {
        
    }
    
    private func fetchData() {
        
    }
    
    private func updateUI() {
        if let strArkworkUrl = self.vm.track?.artworkUrl100 {
            self.imgvArtwork.af.setImage(withURL: URL(string: strArkworkUrl)!)
        }
        if let strTrackName = self.vm.track?.trackName {
            self.lblTrackName.text = strTrackName
        }
        if let strArtistName = self.vm.track?.artistName {
            self.lblArtistName.text = strArtistName
        }
        if let previewUrl =  self.vm.track?.previewUrl {
            self.player.removeAllItems()
            self.player.insert(AVPlayerItem(url: URL(string: previewUrl)!), after: nil)
            self.player.play()
            self.btnPlayAndPause.setImage(UIImage(named: "Stop"), for: .normal)
        }
    }
    
    private func secondToTime(seconds: Double) -> String {
        let m = (Int(seconds) % 3600) / 60
        let s = (Int(seconds) % 3600) % 60
        
        return String(format: "%02d:%02d", m, s)
    }
    
    // MARK: - Button
    
    @IBAction func btnBackOnClick(_ sender: Any) {
        self.player.pause()
        self.dismiss(animated: true)
    }
    
    @IBAction func btnFavouriteOnClick(_ sender: Any) {
        if let track = self.vm.track {
            TrackManager.shared.addFavourite(track: track)
        }
    }
    
    @IBAction func btnSkipPreviousOnClick(_ sender: Any) {
        
    }
    
    @IBAction func btnPlayAndPauseOnClick(_ sender: Any) {
        if self.player.timeControlStatus == .playing {
            self.player.seek(to: CMTime(value: CMTimeValue(0.0), timescale: CMTimeScale(1.0)))
            self.player.pause()
            self.btnPlayAndPause.setImage(UIImage(named: "Play"), for: .normal)
        } else {
            self.player.play()
            self.btnPlayAndPause.setImage(UIImage(named: "Stop"), for: .normal)
        }
    }
    
    @IBAction func btnSkipNextClick(_ sender: Any) {
        
    }
    
}
