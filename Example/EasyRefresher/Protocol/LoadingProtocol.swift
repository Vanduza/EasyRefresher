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
    //视图第一次进入时，执行全屏loading，载入后为刷新加载
//    associatedtype ViewModel: DataLoadingProtocol
    var viewModel: DataLoadingProtocol? { get }
    var listView: UIScrollView? { get }
//    var disposeBag: DisposeBag { get }
//    func reloadData()
//    func setupLoadingState()
}

//extension LoadingProtocol {
//    func setupLoadingState() {
//        listView.refresh.header.addRefreshClosure { [weak self] in
//            self?.listView.refresh.footer.isEnabled = true
//            self?.viewModel.load()
//        }
//
//        listView.refresh.footer.addRefreshClosure { [weak self] in
//            self?.viewModel.loadMore()
//        }
//
//        viewModel.loadEndSignal.subscribe { [weak self] (_) in
//            guard let sself = self else { return }
//            print("loading end")
//            DispatchQueue.main.async {
//                self?.listView.refresh.header.endRefreshing()
//                if sself.listView.refresh.footer.isEnabled {
//                    self?.listView.refresh.footer.endRefreshing()
//                }
//                self?.reloadData()
//            }
//        }.disposed(by: disposeBag);
//
//        viewModel.loadNoMoreSignal.subscribe { [weak self] (_) in
//            print("no more")
//            DispatchQueue.main.async {
//                self?.listView.refresh.footer.isEnabled = false
//            }
//        }.disposed(by: disposeBag)
//
//        viewModel.loadErrorSignal.subscribe { (errMsg) in
//            print("error occurred: \(errMsg)")
//        }.disposed(by: disposeBag);
//
//        viewModel.loadingSignal.subscribe { (_) in
//            print("loading")
//        }.disposed(by: disposeBag)
//    }
//}

protocol DataLoadingProtocol: class {
    
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
    
    /// 加载数据
    func load()
    
    /// 加载更多
    func loadMore()
}
