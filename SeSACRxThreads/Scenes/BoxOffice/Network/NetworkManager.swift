//
//  NetworkManager.swift
//  SeSACRxThreads
//
//  Created by 김성민 on 8/8/24.
//

import Foundation
import RxSwift

enum APIError: Error, LocalizedError {
    case invalidURL
    case unknownResponse
    case statusError
    case noData
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "유효하지 않은 URL"
        case .unknownResponse:
            "알 수 없는 응답"
        case .statusError:
            "상태코드 오류"
        case .noData:
            "데이터 없음"
        case .decodingError:
            "데이터 디코딩 에러"
        }
    }
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func callRequest(targetDt: String) -> Observable<Movie> {
        let url = APIURL.movieURL + "?key=\(APIKey.movieKey)&targetDt=\(targetDt)"
        
        let result = Observable<Movie>.create { observer in
            
            guard let url = URL(string: url) else {
                observer.onError(APIError.invalidURL)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    observer.onError(APIError.unknownResponse)
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode) else {
                    observer.onError(APIError.statusError)
                    return
                }
                
                guard let data else {
                    observer.onError(APIError.noData)
                    return
                }
                
                do {
                    let value = try JSONDecoder().decode(Movie.self, from: data)
                    observer.onNext(value)
                    observer.onCompleted()
                } catch {
                    observer.onError(APIError.decodingError)
                }
            }.resume()
            
            return Disposables.create()
        }
        
        return result
    }
}
