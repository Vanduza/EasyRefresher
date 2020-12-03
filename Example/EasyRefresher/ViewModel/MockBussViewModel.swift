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
        
    private let _page = 15

    override func load() {
        super.load()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
            let result = (0..<self._page).compactMap({$0})
            DispatchQueue.main.async {
                self.items.accept(result)
            }
        })
    }
    
    override func loadMore() {
        super.loadMore()
        
        let random = arc4random() % 2
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            if random == 1 {
                let start = self.items.value.count - 1
                let end = start + self._page
                let result = (start..<end).compactMap({$0})
                var temp = self.items.value
                temp.append(contentsOf: result)
                self.items.accept(temp)
            }else {
                //发生错误时的数据处理，根据业务情况做适当反应
                let elements = self.items.value
                self.items.accept(elements)
                self.loadErrorSignal.onNext("模拟错误")
            }
        }
    }
    
    struct MockItem {
        var id: String
    }
}
