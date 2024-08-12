//
//  SearchViewModel.swift
//  SeSACRxThreads
//
//  Created by 김성민 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel: ViewModelType {
    
    var data = ["A", "B", "C", "AB", "D", "ABC", "BBB", "EC", "SA", "AAAB", "ED", "F", "G", "H"]
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let searchText: ControlProperty<String>
        let barButtonTap: ControlEvent<Void>?
    }
    
    struct Output {
        let list: BehaviorRelay<[String]>
    }
    
    func transform(input: Input) -> Output {
        
        let list = BehaviorRelay<[String]>(value: data)
        
        input.searchText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                print("실시간 검색: \(value)")
                let result = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
                list.accept(result)
            }
            .disposed(by: disposeBag)
        
        input.barButtonTap?
            .withLatestFrom(input.searchText) { void, text in
                return text
            }
            .bind(with: self) { owner, value in
                print("추가: \(value)")
                owner.data.insert(value, at: 0)
                list.accept(owner.data)
            }
            .disposed(by: disposeBag)
        
        return Output(list: list)
    }
}
