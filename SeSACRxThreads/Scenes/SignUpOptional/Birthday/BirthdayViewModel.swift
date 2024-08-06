//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by 김성민 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class BirthdayViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let date: ControlProperty<Date>
        let nextTap: ControlEvent<Void>
    }
    
    struct Output {
        let validation: Observable<Bool>
        let year: BehaviorRelay<Int?>
        let month: BehaviorRelay<Int>
        let day: BehaviorRelay<Int>
        let nextTap: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        
        // MARK: - PublishRelay 쓰면 초기값 적용 x
        let year = BehaviorRelay<Int?>(value: nil)
        let month = BehaviorRelay<Int>(value: 0)
        let day = BehaviorRelay<Int>(value: 987654321)
        
        // 현재 날짜 표시
        input.date
            .bind(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                guard let y = component.year,
                      let m = component.month,
                      let d = component.day else { return }
                year.accept(y)
                month.accept(m)
                day.accept(d)
            }
            .disposed(by: disposeBag)
        
        // 만 17세 이상인지 판별
        let validation = input.date
            .map {
                let component = Calendar.current.dateComponents([.year], from: $0, to: Date())
                guard let age = component.year else { return false }
                return age >= 17
            }
        // MARK: - .share()를 쓰면 첫번째 bind만 적용됨
            .share(replay: 1)
        
        return Output(
            validation: validation,
            year: year,
            month: month,
            day: day,
            nextTap: input.nextTap
        )
    }
}
