//
//  AutoRefreshViewController.swift
//  EasyRefresher_Example
//
//  Created by 杨敬 on 2020/12/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift

class AutoRefreshViewController: UIViewController, LoadingProtocol {
    
    var viewModel: DataLoadingProtocol!
    
    var listView: UIScrollView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                self?.listView.refresh.footer.isEnabled = false
            }
        }.disposed(by: disposeBag)
        
        viewModel.loadErrorSignal.subscribe { (errMsg) in
            print("error occurred: \(errMsg)")
        }.disposed(by: disposeBag);

        viewModel.loadingSignal.subscribe { (_) in
            print("loading")
        }.disposed(by: disposeBag)
    }
    
}
