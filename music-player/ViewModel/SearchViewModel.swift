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
    
    var arrTrack = [Result]()
    var arrPlayedTrack = [Result]()
    var iCurrentTrack = 0
    
    let psLoading = PublishSubject<Bool>()
    let psError = PublishSubject<Error>()
    let psSearchMusic = PublishSubject<(Response)>()
    
    func searchMusic(term strTerm: String?, offset intOffset: Int?, limit intLimit: Int?) {
        var lang = ""
        if (Locale.current.languageCode == "zh") {
            if (Locale.current.regionCode == "HK") {
                lang = Enum.Language.zh_hk.rawValue
            } else {
                lang = Enum.Language.zh_cn.rawValue
            }
        } else {
            lang = Enum.Language.en.rawValue
        }
        
        let params: Parameters = ["term": strTerm ?? "",
                                  "offset": intOffset ?? "",
                                  "limit": intLimit ?? "",
                                  "lang": lang]
        self.psLoading.onNext(true)
        
        AF.request("https://itunes.apple.com/search", method: .get, parameters: params).responseDecodable(of: Response.self, queue: .main) { res in
            switch res.result {
            case .success(let response):
                self.psLoading.onNext(false)
                self.psSearchMusic.onNext(response)

            case .failure(let error):
                self.psLoading.onNext(false)
                self.psError.onNext(error)
                print("Request failed with error: \(error)")
            }
        };
    }
}
