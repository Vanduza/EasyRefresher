//
//  LoadingProtocol.swift
//  EasyRefresher_Example
//
//  Created by 杨敬 on 2020/12/2.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// 由具备刷新功能的视图绑定的协议
protocol LoadingProtocol: class {
    var viewModel: DataLoadingProtocol! { get }
    var listView: UIScrollView! { get }
}

protocol DataLoadingProtocol: class {
    
    /// 加载中
    var loadingSignal: PublishSubject<Void> { get }
    
    /// 没有更多数据
    var loadNoMoreSignal: PublishSubject<Void> { get }
    
    /// 加载完成
    var loadEndSignal: PublishSubject<Void> { get }
    
    /// 加载出错
    var loadErrorSignal: PublishSubject<String> { get }
    
    var dataCountSignal: PublishSubject<Int> { get }
    
    var pageSize: Int { get }
    
    /// 加载数据
    func load()
    
    /// 加载更多
    func loadMore()
}
