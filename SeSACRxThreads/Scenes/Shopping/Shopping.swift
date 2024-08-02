//
//  Shopping.swift
//  SeSACRxThreads
//
//  Created by 김성민 on 8/2/24.
//

import Foundation

struct Shopping {
    let contents: String
    let isSelected: Bool
    let isStar: Bool
    
    static let dummy: [Shopping] = [
        Shopping(contents: "그립톡 구매하기", isSelected: true, isStar: true),
        Shopping(contents: "사이다 구매", isSelected: false, isStar: false),
        Shopping(contents: "아이패드 케이스 최저가 알아보기", isSelected: false, isStar: true),
        Shopping(contents: "양말", isSelected: false, isStar: true),
    ]
}
