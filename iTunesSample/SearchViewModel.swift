//
//  SearchViewModel.swift
//  iTunesSample
//
//  Created by 아라 on 8/8/24.
//

import Foundation
import RxSwift

class SearchViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let searchBtnTap: Observable<String>
        let contentDidSelect: Observable<SearchResult>
    }
    
    struct Output {
        let appList: PublishSubject<[SearchResult]>
        let pushDetailView: PublishSubject<SearchResult>
    }
    
    func transform(input: Input) -> Output {
        let appList = PublishSubject<[SearchResult]>()
        let pushDetailView = PublishSubject<SearchResult>()
        
        input.searchBtnTap
            .distinctUntilChanged()
            .flatMap { value in
                self.fetchContentList(term: value)
            }
            .subscribe(with: self) { owner, value in
                appList.onNext(value.results)
            } onError: { owner, error in
                print(error)
            } onCompleted: { owner in
                print("completed")
            } onDisposed: { owner in
                print("disposed")
            }.disposed(by: disposeBag)
        
        input.contentDidSelect
            .subscribe(with: self) { owner, value in
                pushDetailView.onNext(value)
            }.disposed(by: disposeBag)
        
        return Output(appList: appList,
                      pushDetailView: pushDetailView)
    }
}

extension SearchViewModel {
    func fetchContentList(term: String) -> Observable<SearchResultResponse> {
        let url = "https://itunes.apple.com/search?term=\(term)&country=KR&media=software"
        
        let result = Observable<SearchResultResponse>.create { observer in
            guard let url = URL(string: url) else {
                observer.onError(APIError.invalidURL)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let _ = error {
                    observer.onError(APIError.unknownResponse)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    observer.onError(APIError.statusError)
                    return
                }
                
                if let data = data, let appData = try? JSONDecoder().decode(SearchResultResponse.self, from: data) {
                    observer.onNext(appData)
                    observer.onCompleted()
                } else {
                    print("응답 왔는데 디코딩 실패해씀")
                    observer.onError(APIError.unknownResponse)
                }
            }.resume()
            
            return Disposables.create()
        }
        
        return result
    }
}

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}
