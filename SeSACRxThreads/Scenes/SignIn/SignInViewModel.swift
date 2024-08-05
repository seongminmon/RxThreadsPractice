//
//  SignInViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import Foundation
import RxSwift
import RxCocoa

class SignInViewModel {
    
    struct Input {
        let signInTap: ControlEvent<Void>
        let signUpTap: ControlEvent<Void>
    }
    
    struct Output {
        let signInTap: ControlEvent<Void>
        let signUpTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        return Output(
            signInTap: input.signInTap,
            signUpTap: input.signUpTap
        )
    }
}
