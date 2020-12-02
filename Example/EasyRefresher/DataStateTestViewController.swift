//
//  DataStateTestViewController.swift
//  EasyRefresher_Example
//
//  Created by 杨敬 on 2020/12/2.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift

class DataStateTestViewController: UITableViewController {
    private let _viewModel = MockViewModel()
    private let _bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CELL")
        tableView.tableFooterView = UIView()
        
        tableView.refresh.header.addRefreshClosure { [weak self] in
            self?.tableView.refresh.header.isEnabled = true
            self?._viewModel.load()
        }
        
        tableView.refresh.footer.addRefreshClosure { [weak self] in
            if self?._viewModel.items.value.count ?? 0 > 30 {
                self?.tableView.refresh.footer.isEnabled = false
            }else {
                self?._viewModel.loadMore()
            }
        }
        
        _viewModel.items.subscribeOn(MainScheduler.instance).subscribe { [weak self] (_) in
            self?.tableView.refresh.header.endRefreshing()
            self?.tableView.refresh.footer.endRefreshing()
            self?.tableView.reloadData()
        }.disposed(by: _bag)

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _viewModel.items.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL")!
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    deinit {
        print("dealloc \(type(of: self))")
    }

}
