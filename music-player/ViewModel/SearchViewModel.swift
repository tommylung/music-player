//
//  SearchViewModel.swift
//  music-player
//

import Alamofire
import Foundation
import RxSwift

class SearchViewModel {
    var disposeBag = DisposeBag()
    
    var arrTrack = [Result]()
    var iCurrentTrack = 0
    var iCurrentPage = 1
    var iTrackPerPage = 20
    var bEnd = false
    
    let psLoading = PublishSubject<Bool>()
    let psError = PublishSubject<Error>()
    let psSearchMusic = PublishSubject<(Response)>()
    
    func searchMusic(term strTerm: String, media strMedia: String, country strCountry: String) {
        var lang = ""
        if (Locale.current.languageCode == "zh") {
            if (Locale.current.scriptCode == "Hans") {
                lang = Enum.Language.zh_cn.rawValue
            } else {
                lang = Enum.Language.zh_hk.rawValue
            }
        } else {
            lang = Enum.Language.en.rawValue
        }
        
        let params: Parameters = ["term": strTerm.replacingOccurrences(of: " ", with: "+"),
                                  "offset": self.iCurrentPage * self.iTrackPerPage,
                                  "limit": 20,
                                  "lang": lang,
                                  "media": strMedia,
                                  "country": strCountry]
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
