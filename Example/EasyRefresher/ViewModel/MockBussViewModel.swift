//
//  MockBussViewModel.swift
//  EasyRefresher_Example
//
//  Created by 杨敬 on 2020/12/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class MockBussViewModel: MockViewModel {
    
    typealias Item = MockItem
        
    override var pageSize: Int {
        set {
            super.pageSize = newValue
        }
        get {
            return 10
        }
    }

    override func load() {
        super.load()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
            let result = (0..<self.pageSize).compactMap({$0})
            DispatchQueue.main.async {
                self.items.accept(result)
            }
        })
    }
    
    override func loadMore() {
        super.loadMore()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let start = self.items.value.count - 1
            let end = (start + self.pageSize) < self.total.count ? (start + self.pageSize) : self.total.count

            let result = self.total[start..<end]
            var temp = self.items.value
            temp.append(contentsOf: result)
            self.items.accept(temp)
            //发生错误时的数据处理，根据业务情况做适当反应
//            self.loadErrorSignal.onNext("模拟错误")
        }
    }
    
    private let total = (0..<19).compactMap({ $0 })
    
    struct MockItem {
        var id: String
    }
}
