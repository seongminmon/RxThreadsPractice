//
//  NicknameViewModel.swift
//  SeSACRxThreads
//
//  Created by 김성민 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class NicknameViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let text: ControlProperty<String>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let validation: PublishSubject<Bool>
        let description: PublishSubject<String>
        let tap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let validation = PublishSubject<Bool>()
        let description = PublishSubject<String>()
        
        input.text
            .bind(with: self) { owner, value in
                do {
                    _ = try owner.checkNickname(value)
                    validation.onNext(true)
                    description.onNext("사용 가능한 닉네임이에요")
                } catch {
                    validation.onNext(false)
                    
                    guard let error = error as? NicknameValidationError, let errorDescription = error.errorDescription else {
                        description.onNext("알 수 없는 에러가 발생했습니다")
                        return
                    }
                    description.onNext(errorDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            validation: validation,
            description: description,
            tap: input.tap
        )
    }
    
    enum NicknameValidationError: Error, LocalizedError {
        case length
        case invalidCharacter
        case number
        case whitespace
        
        var errorDescription: String? {
            switch self {
            case .length: "2글자 이상 10글자 미만으로 설정해주세요"
            case .invalidCharacter: "닉네임에 @, #, $, % 는 포함할 수 없어요"
            case .number: "닉네임에 숫자는 포함할 수 없어요"
            case .whitespace: "닉네임에 공백은 포함할 수 없어요"
            }
        }
    }
    
    func checkNickname(_ text: String) throws -> Bool {
        // 1) 2글자 이상 10글자 미만
        guard text.count >= 2 && text.count < 10 else {
            throw NicknameValidationError.length
        }
        // 2) @, #, $, % 사용 불가
        let invalidCharacters = "@#$%"
        guard text.filter({ invalidCharacters.contains($0) }).isEmpty else {
            throw NicknameValidationError.invalidCharacter
        }
        // 3) 숫자 사용 불가
        guard text.filter({ $0.isNumber }).isEmpty else {
            throw NicknameValidationError.number
        }
        // 4) 공백 사용 불가
        guard text.filter({ $0.isWhitespace }).isEmpty else {
            throw NicknameValidationError.whitespace
        }
        return true
    }
}
