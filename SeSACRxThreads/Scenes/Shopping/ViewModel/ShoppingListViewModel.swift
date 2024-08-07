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
    private let recommendData = ["마우스", "키보드", "손풍기", "컵", "샌들", "텀블러"]
    private var data = Shopping.dummy
    
    struct Input {
        let searchText: ControlProperty<String>
        let addTap: ControlEvent<Void>
        let collectionViewCellSelected: ControlEvent<String>
        let tableViewCellSelected: ControlEvent<IndexPath>
        let tableViewCellDeleted: ControlEvent<IndexPath>
        let tableViewCellCheckTap: Observable<Int>
        let tableViewCellStarTap: Observable<Int>
    }
    
    struct Output {
        let list: BehaviorRelay<[Shopping]>
        let cellSelected: Observable<String>
        let recommendList: BehaviorRelay<[String]>
    }
    
    func transform(input: Input) -> Output {
        let recommendList = BehaviorRelay<[String]>(value: recommendData)
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
        
        input.collectionViewCellSelected
            .map { "\($0) 구매하기"}
            .bind(with: self) { owner, value in
                let item = Shopping(contents: value, isComplete: false, isStar: false)
                owner.data.insert(item, at: 0)
                list.accept(owner.data)
            }
            .disposed(by: disposeBag)
        
        input.tableViewCellCheckTap
            .bind(with: self) { owner, row in
                owner.data[row].isComplete.toggle()
                list.accept(owner.data)
            }
            .disposed(by: disposeBag)
        
        input.tableViewCellStarTap
            .bind(with: self) { owner, row in
                owner.data[row].isStar.toggle()
                list.accept(owner.data)
            }
            .disposed(by: disposeBag)
        
        let cellSelected = input.tableViewCellSelected
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
        input.tableViewCellDeleted
            .bind(with: self) { owner, indexPath in
                print("삭제: \(owner.data[indexPath.row])")
                owner.data.remove(at: indexPath.row)
                list.accept(owner.data)
            }
            .disposed(by: disposeBag)
        
        return Output(
            list: list,
            cellSelected: cellSelected,
            recommendList: recommendList
        )
    }
}
