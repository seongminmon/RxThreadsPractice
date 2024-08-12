//
//  SignUpViewModel.swift
//  SeSACRxThreads
//
//  Created by 김성민 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let text: ControlProperty<String>
        let validationTap: ControlEvent<Void>
        let nextTap: ControlEvent<Void>
    }
    
    struct Output {
        let validation: SharedSequence<DriverSharingStrategy, Bool>
        let validationTap: ControlEvent<Void>
        let nextTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let validation = input.text
            .map { $0.count >= 8 }
            .asDriver(onErrorJustReturn: false)
        
        return Output(
            validation: validation,
            validationTap: input.validationTap,
            nextTap: input.nextTap
        )
    }
}
