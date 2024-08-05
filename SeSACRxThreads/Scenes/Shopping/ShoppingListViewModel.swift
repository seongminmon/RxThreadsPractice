//
//  ShoppingListViewModel.swift
//  SeSACRxThreads
//
//  Created by 김성민 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ShoppingListViewModel {
    
    private let disposeBag = DisposeBag()
    private var data = Shopping.dummy
    
    struct Input {
        let searchText: ControlProperty<String>
        let addTap: ControlEvent<Void>
        let cellSelected: ControlEvent<IndexPath>
        let cellDeleted: ControlEvent<IndexPath>
    }
    
    struct Output {
        let list: BehaviorRelay<[Shopping]>
        let cellSelected: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        
        let list = BehaviorRelay<[Shopping]>(value: data)
        
        // 실시간 검색
        input.searchText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                print("실시간 검색: \(value)")
                let result = value.isEmpty ? owner.data : owner.data.filter { $0.contents.contains(value) }
                list.accept(result)
            }
            .disposed(by: disposeBag)
        
        let cellSelected = input.cellSelected
            .map { [weak self] indexPath in
                self?.data[indexPath.row].contents ?? ""
            }
        
        // 데이터 추가
        input.addTap
            .withLatestFrom(input.searchText)
            .bind(with: self) { owner, value in
                guard !value.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                let item = Shopping(contents: value, isComplete: false, isStar: false)
                print("추가: \(item)")
                owner.data.insert(item, at: 0)
                list.accept(owner.data)
            }
            .disposed(by: disposeBag)
        
        // 데이터 삭제
        input.cellDeleted
            .bind(with: self) { owner, indexPath in
                print("삭제: \(owner.data[indexPath.row])")
                owner.data.remove(at: indexPath.row)
                list.accept(owner.data)
            }
            .disposed(by: disposeBag)
        
        return Output(
            list: list,
            cellSelected: cellSelected
        )
    }
}
