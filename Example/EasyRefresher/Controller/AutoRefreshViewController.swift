//
//  AutoRefreshViewController.swift
//  EasyRefresher_Example
//
//  Created by 杨敬 on 2020/12/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import DZNEmptyDataSet

class AutoRefreshViewController: UIViewController, LoadingProtocol {
    //由子类重写
    var viewModel: DataLoadingProtocol!
    //由子类重写
    var listView: UIScrollView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard listView != nil, viewModel != nil else {
            fatalError("子类重写这两个属性")
        }
        
        listView.emptyDataSetSource = self
        listView.emptyDataSetDelegate = self
        
        listView.refresh.header.addRefreshClosure { [weak self] in
            self?.listView.refresh.footer.isEnabled = true
            self?.viewModel.load()
        }
        
        listView.refresh.footer.addRefreshClosure { [weak self] in
            self?.viewModel.loadMore()
        }
        
        viewModel.loadEndSignal.subscribe { [weak self] (_) in
            guard let sself = self, let list = sself.listView else { return }
            print("loading end")
            DispatchQueue.main.async {
                self?.listView.refresh.header.endRefreshing()
                if list.refresh.footer.isEnabled {
                    self?.listView.refresh.footer.endRefreshing()
                }
            }
        }.disposed(by: disposeBag);

        viewModel.loadNoMoreSignal.subscribe { [weak self] (_) in
            print("no more")
            DispatchQueue.main.async {
                self?.listView.refresh.header.endRefreshing()
                self?.listView.refresh.footer.isEnabled = false
            }
        }.disposed(by: disposeBag)
        
        viewModel.loadErrorSignal.subscribe { [weak self] (errMsg) in
            print("error occurred: \(errMsg)")
            guard let sself = self, let list = sself.listView else { return }
            DispatchQueue.main.async {
                self?.listView.refresh.header.endRefreshing()
                if list.refresh.footer.isEnabled {
                    self?.listView.refresh.footer.endRefreshing()
                }
            }
        }.disposed(by: disposeBag);

        viewModel.loadingSignal.subscribe { (_) in
            print("loading")
        }.disposed(by: disposeBag)
    }
    
}

extension AutoRefreshViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attr = NSAttributedString.init(string: "这是一个空视图")
        return attr
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        viewModel.load()
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        let attr = NSAttributedString.init(string: "重试")
        return attr
    }
}
