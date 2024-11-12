//
//  DetailViewModel.swift
//  iTunesSample
//
//  Created by 아라 on 8/13/24.
//

import Foundation
import RxSwift

class DetailViewModel {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let receiveData: Observable<SearchResult>
    }
    
    struct Output {
        let configureData: PublishSubject<SearchResult>
    }
    
    func transform(input: Input) -> Output {
        let configureData = PublishSubject<SearchResult>()
        input.receiveData
            .bind(to: configureData)
            .disposed(by: disposeBag)
        return Output(configureData: configureData)
    }
}
