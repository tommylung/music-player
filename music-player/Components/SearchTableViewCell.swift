//
//  SearchTableViewCell.swift
//  music-player
//

import RxSwift
import SnapKit

class SearchTableViewCell: UITableViewCell {

    var disposeBag = DisposeBag()
    
    var imgvArtwork = UIImageView()
    var lblTrackName = UILabel()
    var lblArtistName = UILabel()
}
