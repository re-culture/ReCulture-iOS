//
//  RecordType.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 5/26/24.
//

import Foundation

/// 기록의 종류를 정리한  Enum
enum RecordType: String {
    case movie = "영화"
    case musical = "뮤지컬"
    case play = "연극"
    case sports = "스포츠"
    case concert = "콘서트"
    case drama = "드라마"
    case book = "독서"
    case exhibition = "전시회"
    case etc = "기타"
    
    static let allTypes = [movie, musical, play, sports, concert, drama, book, exhibition, etc]
    
    static func getAllRecordTypes() -> [String] {
        return RecordType.allTypes.map { $0.rawValue }
    }
}
