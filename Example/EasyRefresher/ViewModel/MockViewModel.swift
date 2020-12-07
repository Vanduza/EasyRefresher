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
    var dataCountSignal: PublishSubject<Int> = PublishSubject.init()
    
    var pageSize: Int = 15
    
    var loadingSignal: PublishSubject<Void> = PublishSubject.init()
    
    var loadNoMoreSignal: PublishSubject<Void> = PublishSubject.init()
    
    var loadEndSignal: PublishSubject<Void> = PublishSubject.init()
    
    var loadErrorSignal: PublishSubject<String> = PublishSubject.init()
    
    private let _disposeBag = DisposeBag()
    private var _dataCount: Int = 0
    init() {
        dataCountSignal.subscribe { [weak self] (count: Int) in
            guard let sself = self else { return }
            let increment = count - sself._dataCount > 0 ? count - sself._dataCount : 0
            if increment < sself.pageSize {
                //loadNoMore的信号中有处理loadEnd的逻辑
                sself.loadNoMoreSignal.onNext(())
            } else {
                sself.loadEndSignal.onNext(())
            }
            sself._dataCount = count
        }.disposed(by: _disposeBag)
    }
    
    func load() {
        loadingSignal.onNext(())
    }
    
    func loadMore() {
        loadingSignal.onNext(())
    }
}
