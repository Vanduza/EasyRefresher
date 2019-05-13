// 
//  AppearanceRefreshFooter.swift
//  EasyRefresher
//
//  Created by Pircate(swifter.dev@gmail.com) on 2019/5/11
//  Copyright © 2019 Pircate. All rights reserved.
//

open class AppearanceRefreshFooter: RefreshFooter {
    
    public override var state: RefreshState {
        get { return super.state }
        set {
            guard newValue == .idle else {
                super.state = newValue
                return
            }
            
            super.state = .pulling
        }
    }
    
    public override init(refreshClosure: @escaping () -> Void) {
        super.init(refreshClosure: refreshClosure)
        
        self.alpha = 1
        configurateStateTitles()
        addTapGestureRecognizer()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.alpha = 1
        configurateStateTitles()
        addTapGestureRecognizer()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.alpha = 1
        configurateStateTitles()
        addTapGestureRecognizer()
    }
    
    override func willBeginRefreshing(completion: @escaping () -> Void) {
        guard let scrollView = scrollView else { return }
        
        UIView.animate(withDuration: 0.25, animations: {
            scrollView.contentInset.bottom = self.originalInset.bottom + 54
            scrollView.changed_inset.bottom = 54
        }, completion: { _ in completion() })
    }
    
    override func didEndRefreshing(completion: @escaping () -> Void) {
        guard let scrollView = scrollView else { return }
        
        UIView.animate(withDuration: 0.25, animations: {
            scrollView.contentInset.bottom += scrollView.changed_inset.bottom
            scrollView.changed_inset.bottom = 54
        }, completion: { _ in completion() })
    }
    
    override func scrollViewContentOffsetDidChange(_ scrollView: UIScrollView) {
        scrollView.contentInset.bottom = originalInset.bottom + 54
        scrollView.changed_inset.bottom = 54
        
        super.scrollViewContentOffsetDidChange(scrollView)
    }
    
    override func changeState(by offset: CGFloat) {
        switch offset {
        case 54...:
            state = .willRefresh
        default:
            state = .pulling
        }
    }
}

extension AppearanceRefreshFooter {
    
    private func configurateStateTitles() {
        stateTitles = [.pulling: "点击或上拉加载更多",
                       .willRefresh: "松开立即加载更多",
                       .refreshing: "正在加载更多的数据..."]
    }
    
    private func addTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(tapGestureAction(sender:)))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapGestureAction(sender: UITapGestureRecognizer) {
        beginRefreshing()
    }
}
