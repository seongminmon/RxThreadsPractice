//
//  ViewModelType.swift
//  SeSACRxThreads
//
//  Created by 김성민 on 8/12/24.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}
