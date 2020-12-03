//
//  DataStateTestViewController.swift
//  EasyRefresher_Example
//
//  Created by 杨敬 on 2020/12/2.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class DataStateTestViewController: UITableViewController {

    var viewModel = MockBussViewModel()
    
    private let _bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingState()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CELL")
        tableView.tableFooterView = UIView()
        tableView.delegate = nil
        tableView.dataSource = nil

        viewModel.items.bind(to: tableView.rx.items(cellIdentifier: "CELL", cellType: UITableViewCell.self)){ (index, item, cell) in
            cell.textLabel?.text = "\(index)"
        }.disposed(by: disposeBag)

    }
    
    deinit {
        print("dealloc \(type(of: self))")
    }

}

extension DataStateTestViewController: LoadingProtocol {
    var listView: UIScrollView {
        return self.tableView
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    var disposeBag: DisposeBag {
        return _bag
    }
}
