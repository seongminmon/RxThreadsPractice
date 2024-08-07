//
//  Shopping.swift
//  SeSACRxThreads
//
//  Created by 김성민 on 8/2/24.
//

import Foundation

struct Shopping {
    var contents: String
    var isComplete: Bool
    var isStar: Bool
    
    static let dummy: [Shopping] = [
        Shopping(contents: "그립톡 구매하기", isComplete: true, isStar: true),
        Shopping(contents: "사이다 구매", isComplete: false, isStar: false),
        Shopping(contents: "아이패드 케이스 최저가 알아보기", isComplete: false, isStar: true),
        Shopping(contents: "양말", isComplete: false, isStar: true),
    ]
}
