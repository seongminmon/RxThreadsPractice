//
//  BoxOfficeViewModel.swift
//  SeSACRxThreads
//
//  Created by 김성민 on 8/7/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BoxOfficeViewModel {
    
    private let disposeBag = DisposeBag()
    
    private var recentList = ["1", "2", "3"]
    private var movieList = ["test1", "test2", "test3"]
    
    struct Input {
        // 테이블뷰 선택시 컬렉션뷰에 데이터 추가하기
        let tablViewCellTap: ControlEvent<String>
        let searchText: ControlProperty<String>
        let searchButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let recentList: BehaviorSubject<[String]>
        let movieList: BehaviorSubject<[String]>
    }
    
    func transform(input: Input) -> Output {
        let recentList = BehaviorSubject(value: recentList)
        
        input.tablViewCellTap
            .subscribe(with: self) { owner, value in
                print("테이블뷰 셀 탭", value)
                owner.recentList.append(value)
                recentList.onNext(owner.recentList)
            }
            .disposed(by: disposeBag)
        
        input.searchButtonTap
            .withLatestFrom(input.searchText)
            .subscribe(with: self) { owner, value in
                print("서치 버튼 탭", value)
            }
            .disposed(by: disposeBag)
        
        return Output(
            recentList: recentList,
            movieList: BehaviorSubject(value: movieList)
        )
    }
}
