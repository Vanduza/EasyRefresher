//
//  CustomFooterViewController.swift
//  EasyRefresher_Example
//
//  Created by 杨敬 on 2020/11/30.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import EasyRefresher

class CustomFooterViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let v = UITableView()
        v.tableFooterView = UIView()
        v.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        v.delegate = self
        v.dataSource = self
        return v
    }()
    
    var dataArray: [String] = ["", "", "", "", ""]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.refresh.header.addRefreshClosure { [weak self] in
            self?.reqeust {
                self?.dataArray = ["", "", "", "", ""]
                self?.tableView.refresh.header.endRefreshing()
                self?.tableView.refresh.footer.isEnabled = true
                self?.tableView.reloadData()
            }
        }
        
        tableView.refresh.header.beginRefreshing()
        tableView.refresh.footer = CustomFooter.init(stateView: CustomFooterStateView(), height: CustomFooter.height, delegate: self)
    }
    
    private func reqeust(completion: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    deinit {
        print("dealloc \(type(of: self))")
    }

}

extension CustomFooterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID")!
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}

extension CustomFooterViewController: RefreshDelegate {
    func refresherDidRefresh(_ refresher: Refresher) {
        self.reqeust {
            self.dataArray.append(contentsOf: ["", "", "", "", ""])
            self.tableView.refresh.footer.isEnabled = false
            self.tableView.reloadData()
        }
    }
}

// MARK: - 自定义Footer
class CustomFooter: RefreshFooter {
    static let height: CGFloat = 100
    override init<T>(stateView: T, height: CGFloat, delegate: RefreshDelegate) where T : UIView, T : RefreshStateful {
        super.init(stateView: stateView, height: height, delegate: delegate)
        self.automaticallyChangeAlpha = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomFooterStateView: UIView, RefreshStateful {
    private lazy var imageView: UIImageView = {
        let v = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        v.backgroundColor = .gray
        return v
    }()
    func refresher(_ refresher: Refresher, didChangeState state: RefreshState) {
        if state == .disabled {
            self.addSubview(imageView)
        }else {
            imageView.removeFromSuperview()
        }
    }
    
    func refresher(_ refresher: Refresher, didChangeOffset offset: CGFloat) {
        
    }
}
