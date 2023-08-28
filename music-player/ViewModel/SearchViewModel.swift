//
//  SearchViewModel.swift
//  music-player
//

import Alamofire
import Foundation
import RxSwift
import SwiftyJSON

class SearchViewModel {
    var disposeBag = DisposeBag()
    
    var arrTrack = [NSDictionary]()
    var arrPlayedTrack = [NSDictionary]()
    var iCurrentTrack = 0
    
    let psLoading = PublishSubject<Bool>()
    let psError = PublishSubject<Error>()
    let psSearchMusic = PublishSubject<(NSDictionary)>()
    
    func searchMusic(term strTerm: String?, offset intOffset: Int?, limit intLimit: Int?) {
        let params: Parameters = ["term": strTerm ?? "", "offset": intOffset ?? "", "limit": intLimit ?? ""]
        self.psLoading.onNext(true)
        
        AF.request("https://itunes.apple.com/search", method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let json):
                self.psLoading.onNext(false)
                if let dictJson = json as? NSDictionary {
                    self.psSearchMusic.onNext(dictJson)
                    print("Results: \(dictJson)")
                }
            case .failure(let error):
                self.psLoading.onNext(false)
                self.psError.onNext(error)
                print("Request failed with error: \(error)")
            }
        };
    }
}
