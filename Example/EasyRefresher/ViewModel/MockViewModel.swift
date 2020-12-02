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
    
    init() {
        items.subscribe { [weak self] (result: [Int]) in
            guard let sself = self else { return }
            sself.loadEndSignal.publish().subscribe().dispose()
            if result.count > 20 {
                sself.loadNoMoreSignal.publish().subscribe().dispose()
            }
        }.disposed(by: _disposeBag)
    }
    
    func loadRetry() {
        load()
    }
    
    func load() {
        loadingSignal.publish().subscribe().dispose()
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
            let result = (0..<5).compactMap({$0})
            DispatchQueue.main.async {
                self.items.accept(result)
            }
        })
    }
    
    func loadMore() {
        let random = arc4random() % 2
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            if random == 1 {
                let start = self.items.value.count - 1
                let end = start + 5
                let result = (start..<end).compactMap({$0})
                var temp = self.items.value
                temp.append(contentsOf: result)
                DispatchQueue.main.async {
                    self.items.accept(temp)
                }
            }else {
                DispatchQueue.main.async {
                    self.loadErrorSignal.publish().subscribe().dispose()
                }
            }
            
        }
    }
}
