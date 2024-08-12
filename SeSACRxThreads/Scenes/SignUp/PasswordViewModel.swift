//
//  PasswordViewModel.swift
//  SeSACRxThreads
//
//  Created by 김성민 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class PasswordViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let text: ControlProperty<String>
        let nextTap: ControlEvent<Void>
    }
    
    struct Output {
        let validation: Observable<Bool>
        let nextTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let validation = input.text
            .map { $0.count >= 8 }
        
        return Output(
            validation: validation,
            nextTap: input.nextTap
        )
    }
}
