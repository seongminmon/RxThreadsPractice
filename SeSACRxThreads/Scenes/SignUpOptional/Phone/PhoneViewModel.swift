//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 김성민 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class PhoneViewModel {
    
    struct Input {
        let text: ControlProperty<String>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let validation: Observable<Bool>
        let tap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        // 10자리, 숫자만 가능
        let validation = input.text
            .map { $0.count == 10 && Int($0) != nil }
        
        return Output(
            validation: validation,
            tap: input.tap
        )
    }
}
