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
protocol LoadingProtocol {
    //视图第一次进入时，执行全屏loading，载入后为刷新加载
    associatedtype ViewModel: DataLoadingProtocol
    var viewModel: ViewModel { get }
}

protocol DataLoadingProtocol {
    
    /// 加载中
    var loadingSignal: PublishSubject<Void> { get }
    
    /// 没有更多数据
    var loadNoMoreSignal: PublishSubject<Void> { get }
    
    /// 加载完成
    var loadEndSignal: PublishSubject<Void> { get }
    
    /// 加载出错
    var loadErrorSignal: PublishSubject<String> { get }
    
    /// 加载重试
    func loadRetry()
}
