//
//  PlayerViewModel.swift
//  music-player
//

import RxSwift

class PlayerViewModel {
    // Create a PS for dismiss the modal presentation
    // Normally will use for reload the favourite function
    let psDismiss = PublishSubject<()>()
    
    var track: Result?
}
