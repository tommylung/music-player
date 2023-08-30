//
//  TrackManager.swift
//  music-player
//

class TrackManager {
    static let shared = TrackManager()
    
    private var arrFavourite: [Result] = [Result]()
    
    private init() {
        self.arrFavourite.removeAll()
    }
    
    func addFavourite(track: Result) {
        self.arrFavourite.append(track)
    }
    
    func getFavourite() -> [Result] {
        return arrFavourite
    }
}
