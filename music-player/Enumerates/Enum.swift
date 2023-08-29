//
//  Enum.swift
//  music-player
//

struct Enum {
    enum Language: String {
        case en = "en_us"
        case zh_cn = "zh_cn"
        case zh_hk = "zh_hk"
    }
    
    enum MediaType: String, CaseIterable {
        case all, movie, music, musicVideo, tvShow
        
        var localizationString: String {
            get {
                switch self {
                case .all:
                    return "musictype_all"
                case .movie:
                    return "musictype_movie"
                case .music:
                    return "musictype_music"
                case .musicVideo:
                    return "musictype_music_video"
                case .tvShow:
                    return "musictype_tvshow"
                }
            }
        }
    }
    
    enum Country: String, CaseIterable {
        case all, us, cn, hk, tw
        
        var localizationString: String {
            get {
                switch self {
                case .all:
                    return "country_all"
                case .cn:
                    return "country_cn"
                case .hk:
                    return "country_hk"
                case .tw:
                    return "country_tw"
                case .us:
                    return "country_us"
                }
            }
        }
        
        var code: String {
            get {
                switch self {
                case .all:
                    return ""
                case .cn:
                    return "cn"
                case .hk:
                    return "hk"
                case .tw:
                    return "tw"
                case .us:
                    return "us"
                }
            }
        }
    }
}
