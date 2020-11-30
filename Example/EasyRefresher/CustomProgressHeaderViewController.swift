//
//  CustomProgressHeaderViewController.swift
//  EasyRefresher_Example
//
//  Created by 杨敬 on 2020/11/30.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import EasyRefresher

class CustomProgressHeaderViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let v = UITableView()
        v.tableFooterView = UIView()
        v.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        v.refresh.header = CustomHeader.init(stateView: CustomStateView.init(frame: .zero), height: CustomStateView.height, delegate: self)
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
        
        tableView.refresh.header.beginRefreshing()
        
        tableView.refresh.footer = AutoRefreshFooter(triggerMode: .percent(0.5)) { [weak self] in
            self?.reqeust {
                self?.dataArray.append(contentsOf: ["", "", "", "", ""])
                self?.tableView.refresh.footer.endRefreshing()
                self?.tableView.reloadData()
            }
        }
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

extension CustomProgressHeaderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID")!
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}


extension CustomProgressHeaderViewController: RefreshDelegate {
    func refresherDidRefresh(_ refresher: Refresher) {
        self.reqeust {
            self.dataArray = ["", "", "", "", ""]
            self.tableView.refresh.header.endRefreshing()
            self.tableView.reloadData()
        }
    }
}
// MARK: - 自定义进度刷新视图
class CustomHeader: RefreshHeader {

    override init<T>(stateView: T, height: CGFloat, delegate: RefreshDelegate) where T : UIView, T : RefreshStateful {
        super.init(stateView: stateView, height: height, delegate: delegate)
        self.automaticallyChangeAlpha = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomStateView: UIView, RefreshStateful {
    static let height: CGFloat = 100
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refresher(_ refresher: Refresher, didChangeState state: RefreshState) {
        
    }
    
    func refresher(_ refresher: Refresher, didChangeOffset offset: CGFloat) {
        let p = offset/CustomStateView.height
        _progress = p
        setNeedsDisplay()
    }
    
    private var _progress: CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        let lineY: CGFloat = (rect.size.height + rect.origin.y - 2)
        ctx?.move(to: CGPoint.init(x: 0, y: lineY))
        ctx?.addLine(to: CGPoint.init(x: rect.size.width * _progress, y: lineY))
        ctx?.setLineWidth(2)
        ctx?.setStrokeColor(UIColor.blue.cgColor)
        ctx?.strokePath()
    }
}
