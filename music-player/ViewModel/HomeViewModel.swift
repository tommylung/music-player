//
//  HomeViewModel.swift
//  music-player
//

import Alamofire
import Foundation
import RxSwift

class HomeViewModel {
    var disposeBag = DisposeBag()
    
    var arrFavourite: [Result] = [Result]()
    var arrArtist: [String] = [String]()
    var dictTrack: [String:[Result]] = [String:[Result]]()
    
    let psLoading = PublishSubject<Bool>()
    let psError = PublishSubject<Error>()
    let psSearchMusic1 = PublishSubject<(String, Response)>()
    let psSearchMusic2 = PublishSubject<(String, Response)>()
    let psSearchMusic3 = PublishSubject<(String, Response)>()
    
    func searchMusic(term strTerm: String, number iNumber: Int) {
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
                                  "offset": 5,
                                  "limit": 5,
                                  "lang": lang,
                                  "media": Enum.MediaType.music,
                                  "country": Enum.Country.hk]
        self.psLoading.onNext(true)
        
        AF.request("https://itunes.apple.com/search", method: .get, parameters: params).responseDecodable(of: Response.self, queue: .main) { res in
            switch res.result {
            case .success(let response):
                self.psLoading.onNext(false)
                if (iNumber == 1) {
                    self.psSearchMusic1.onNext((strTerm, response))
                } else if (iNumber == 2) {
                    self.psSearchMusic2.onNext((strTerm, response))
                } else {
                    self.psSearchMusic3.onNext((strTerm, response))
                }

            case .failure(let error):
                self.psLoading.onNext(false)
                self.psError.onNext(error)
                print("Request failed with error: \(error)")
            }
        };
    }
}
