//
//  BoxOfficeViewModel.swift
//  SeSACRxThreads
//
//  Created by 김성민 on 8/7/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BoxOfficeViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    private var recentList = ["1", "2", "3"]
    private var movieList: [DailyBoxOfficeList] = []
    
    struct Input {
        // 테이블뷰 선택시 컬렉션뷰에 데이터 추가하기
        let tablViewCellTap: ControlEvent<DailyBoxOfficeList>
        let searchText: ControlProperty<String>
        let searchButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let recentList: BehaviorSubject<[String]>
        let movieList: PublishSubject<[DailyBoxOfficeList]>
    }
    
    func transform(input: Input) -> Output {
        
        let recentList = BehaviorSubject(value: recentList)
        let movieList = PublishSubject<[DailyBoxOfficeList]>()
        
        input.tablViewCellTap
            .subscribe(with: self) { owner, value in
                print("테이블뷰 셀 탭", value)
                owner.recentList.append(value.movieNm)
                recentList.onNext(owner.recentList)
            }
            .disposed(by: disposeBag)
        
        input.searchButtonTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .distinctUntilChanged()
            .map { Int($0) ?? 20240807 }
            .map { "\($0)" }
            .flatMap { 
                NetworkManager.shared.callRequestWithSingle(targetDt: $0)
                    .catch { error in
                        if let error = error as? APIError,
                            let errorDescription = error.errorDescription {
                            print(errorDescription)
                        }
                        return Single<Movie>.just(Movie(boxOfficeResult: BoxOfficeResult(dailyBoxOfficeList: [])))
                    }
            }
            .subscribe(with: self) { owner, movie in
                owner.movieList = movie.boxOfficeResult.dailyBoxOfficeList
                movieList.onNext(owner.movieList)
            }
            .disposed(by: disposeBag)
        
        return Output(
            recentList: recentList,
            movieList: movieList
        )
    }
}
