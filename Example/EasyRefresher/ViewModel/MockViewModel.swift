//
//  MockViewModel.swift
//  EasyRefresher_Example
//
//  Created by 杨敬 on 2020/12/2.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import RxCocoa

class MockViewModel {
    let items: BehaviorRelay<[Int]> = BehaviorRelay.init(value: [])
    
    func load() {
        let result = (0..<5).compactMap({$0})
        items.accept(result)
    }
    
    func loadMore() {
        let start = items.value.count - 1
        let end = start + 5
        let result = (start...end).compactMap({$0})
        var temp = items.value
        temp.append(contentsOf: result)
        items.accept(temp)
    }
}
