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

class DataStateTestViewController: AutoRefreshViewController {
    
    override var viewModel: DataLoadingProtocol! {
        get {
            return _viewModel
        }

        set {
            super.viewModel = newValue
        }
    }
    
    override var listView: UIScrollView! {
        get {
            return tableView
        }
        
        set {
            super.listView = newValue
        }
    }
    
    private lazy var tableView: UITableView = {
        let v = UITableView.init(frame: self.view.bounds)
        return v
    }()
    
    private let _viewModel = MockBussViewModel()
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CELL")
        tableView.tableFooterView = UIView()
        tableView.delegate = nil
        tableView.dataSource = nil

        guard let vm = viewModel as? MockBussViewModel else { return }
        vm.items.bind(to: tableView.rx.items(cellIdentifier: "CELL", cellType: UITableViewCell.self)){ (index, item, cell) in
            cell.textLabel?.text = "\(index)"
        }.disposed(by: disposeBag)

        viewModel?.load()
    }
    
    deinit {
        print("dealloc \(type(of: self))")
    }

}
