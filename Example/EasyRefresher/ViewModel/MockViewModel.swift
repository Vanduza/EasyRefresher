//
//  MockViewModel.swift
//  EasyRefresher_Example
//
//  Created by 杨敬 on 2020/12/2.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class MockViewModel: DataLoadingProtocol {
    var loadingSignal: PublishSubject<Void> = PublishSubject.init()
    
    var loadNoMoreSignal: PublishSubject<Void> = PublishSubject.init()
    
    var loadEndSignal: PublishSubject<Void> = PublishSubject.init()
    
    var loadErrorSignal: PublishSubject<String> = PublishSubject.init()
    
    let items: BehaviorRelay<[Int]> = BehaviorRelay.init(value: [])
    
    private let _disposeBag = DisposeBag()
    private var _dataCount = 0
    
    init() {
        items.subscribe { [weak self] (result: [Int]) in
            guard let sself = self else { return }
            sself.loadEndSignal.onNext(())
            if result.count == sself._dataCount {
                sself.loadNoMoreSignal.onNext(())
            }
            sself._dataCount = result.count
        }.disposed(by: _disposeBag)
    }
    
    func loadRetry() {
        load()
    }
    
    func load() {
        loadingSignal.onNext(())
    }
    
    func loadMore() {
        loadingSignal.onNext(())
    }
}
