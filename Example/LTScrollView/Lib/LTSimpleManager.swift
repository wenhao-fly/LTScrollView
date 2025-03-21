 //
 //  LTSimpleManager.swift
 //  LTScrollView
 //
 //  Created by 高刘通 on 2018/2/3.
 //  Copyright © 2018年 LT. All rights reserved.
 //
 
 import UIKit
 
 @objc public protocol LTSimpleScrollViewDelegate: class {
    @objc optional func glt_scrollViewDidScroll(_ scrollView: UIScrollView)
    @objc optional func glt_scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    @objc optional func glt_scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    @objc optional func glt_scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    @objc optional func glt_scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    @objc optional func glt_scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    //刷新tableView的代理方法
    @objc optional func glt_refreshScrollView(_ scrollView: UIScrollView, _ index: Int);
    
 }
 
 public class LTSimpleManager: UIView {
    
    /* headerView配置 */
    @objc public func configHeaderView(_ handle: (() -> UIView?)?) {
        guard let handle = handle else { return }
        guard let headerView = handle() else { return }
        kHeaderHeight = CGFloat(Int(headerView.bounds.height))
        headerView.frame.size.height = kHeaderHeight
        self.headerView = headerView
        tableView.tableHeaderView = headerView
    }
    
    /* 动态改变header的高度 */
    @objc public var glt_headerHeight: CGFloat = 0.0 {
        didSet {
            kHeaderHeight = glt_headerHeight
            headerView?.frame.size.height = kHeaderHeight
            tableView.tableHeaderView = headerView
        }
    }
     
    /* 动态改变整个的高度 */
    @objc public var glt_tableViewHeight: CGFloat = 0.0 {
        didSet {
            var selfFrame = self.frame
            selfFrame.size.height = glt_tableViewHeight
            self.frame = selfFrame
            
            var tableViewFrame = tableView.frame
            tableViewFrame.size.height = glt_tableViewHeight
            tableView.frame = tableViewFrame
            
            var pageViewFrame = pageView.frame
            pageViewFrame.size.height = glt_tableViewHeight
            pageView.frame = pageViewFrame
            
            var pageViewScrollViewFrame = pageView.scrollView.frame
            pageViewScrollViewFrame.size.height = glt_tableViewHeight
            pageView.scrollView.frame = pageViewScrollViewFrame
            
            tableView.reloadData()
        }
    }
    
    public typealias LTSimpleDidSelectIndexHandle = (Int) -> Void
    @objc public var sampleDidSelectIndexHandle: LTSimpleDidSelectIndexHandle?
    @objc  public func didSelectIndexHandle(_ handle: LTSimpleDidSelectIndexHandle?) {
        sampleDidSelectIndexHandle = handle
    }
    
    public typealias LTSimpleRefreshTableViewHandle = (UIScrollView, Int) -> Void
    @objc public var simpleRefreshTableViewHandle: LTSimpleRefreshTableViewHandle?
    @objc public func refreshTableViewHandle(_ handle: LTSimpleRefreshTableViewHandle?) {
        simpleRefreshTableViewHandle = handle
    }
    
    /* add禁止左边table手势的index */
    @objc public func fdoubleIndexArray(array:NSArray) {
//        self.tableView.doubleIndexArray = NSArray.init(array: array)
    }
    
    /* 代码设置滚动到第几个位置 */
    @objc public func scrollToIndex(index: Int)  {
        pageView.scrollToIndex(index: index)
    }
     
     /* 改变整个view颜色 即tableView颜色*/
     @objc public func changeBackgroundColor(color: UIColor)  {
         tableView.backgroundColor = color;
     }
     
     /* 改变下部分view颜色 */
     @objc public func changeCellBackgroundColor(color: UIColor)  {
         if(0 < tableView.numberOfRows(inSection: 0)) {
             let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
             cell?.contentView.backgroundColor = color
         }
     }
     
     /* 是否tableView上下滚动  */
     @objc public func scrollEnabled(enabled: Bool)  {
         tableView.isScrollEnabled = enabled;
     }
     
     /* 是否tableView弹性  */
     @objc public func bouncesEnabled(enabled: Bool)  {
         tableView.bounces = enabled;
     }
    
    /* 点击切换滚动过程动画  */
    @objc public var isClickScrollAnimation = false {
        didSet {
            pageView.isClickScrollAnimation = isClickScrollAnimation
        }
    }
     
     /* tableview滚动到遮住head */
     @objc public func scrollToHideHeader()  {
         tableView.setContentOffset(CGPoint(x: 0, y: kHeaderHeight), animated: true)
     }
     
     /* tableview滚动顶部 */
     @objc public func needScrollToTop()  {
         isNeedScrollToTop = true;
         tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
         DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.0, execute: { [self] in
             isNeedScrollToTop = false
         })
     }
    
    //设置悬停位置Y值
    @objc public var hoverY: CGFloat = 0
     
     //设置滚动到顶部
     @objc public var isNeedScrollToTop: Bool = false
    
    /* LTSimple的scrollView上下滑动监听 */
    @objc public weak var delegate: LTSimpleScrollViewDelegate?
    
    private var contentTableView: UIScrollView?
    private var kHeaderHeight: CGFloat = 0.0
    private var headerView: UIView?
    private var viewControllers: [UIViewController]
    private var titles: [String]
    private weak var currentViewController: UIViewController?
    @objc public var pageView: LTPageView!
    private var currentSelectIndex: Int = 0
    
    private lazy var tableView: LTTableView = {
        let tableView = LTTableView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height), style:.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        registerCell(tableView, UITableViewCell.self)
        return tableView
    }()
    
    @objc public init(frame: CGRect, viewControllers: [UIViewController], titles: [String], currentViewController:UIViewController, layout: LTLayout) {
        UIScrollView.initializeOnce()
        self.viewControllers = viewControllers
        self.titles = titles
        self.currentViewController = currentViewController
        super.init(frame: frame)
        layout.isSinglePageView = true
        pageView = createPageViewConfig(currentViewController: currentViewController, layout: layout)
        createSubViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocConfig()
    }
 }
 
 extension LTSimpleManager {
    
    private func createPageViewConfig(currentViewController:UIViewController, layout: LTLayout) -> LTPageView {
        let pageView = LTPageView(frame: CGRect(x: layout.lrCellMargin, y: 0, width: self.bounds.width-2*layout.lrCellMargin, height: self.bounds.height), currentViewController: currentViewController, viewControllers: viewControllers, titles: titles, layout:layout)
        pageView.delegate = self
        return pageView
    }
 }
 
 extension LTSimpleManager: LTPageViewDelegate {
    
    public func glt_scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.tableView.isScrollEnabled = false
    }
    
    public func glt_scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.tableView.isScrollEnabled = true
    }
    
 }
 
 extension LTSimpleManager {
    
    private func createSubViews() {
        backgroundColor = UIColor.white
        addSubview(tableView)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        refreshData()
        pageViewDidSelectConfig()
        guard let viewController = viewControllers.first else { return }
        viewController.beginAppearanceTransition(true, animated: true)
        contentScrollViewScrollConfig(viewController)
    }
    
    /*
     * 当滑动底部tableView的时候，当tableView的contentOffset.y 小于 header的高的时候，将内容ScrollView的contentOffset设置为.zero
     */
    private func contentScrollViewScrollConfig(_ viewController: UIViewController) {
        viewController.glt_scrollView?.scrollHandle = {[weak self] scrollView in
            guard let `self` = self else { return }
            self.contentTableView = scrollView
            if self.tableView.contentOffset.y  < self.kHeaderHeight - self.hoverY {
                scrollView.contentOffset = CGPoint(x: 0, y: 0)
                scrollView.showsVerticalScrollIndicator = false
            }else{
                scrollView.showsVerticalScrollIndicator = true
            }
        }
    }
    
 }
 
 extension LTSimpleManager {
    private func refreshData()  {
        DispatchQueue.main.after(0.001) {
            UIView.animate(withDuration: 0.34, animations: {
                self.tableView.contentInset = .zero
            })
            self.simpleRefreshTableViewHandle?(self.tableView, self.currentSelectIndex)
            self.delegate?.glt_refreshScrollView?(self.tableView, self.currentSelectIndex)
        }
        
    }
 }
 
 extension LTSimpleManager {
    private func pageViewDidSelectConfig()  {
        pageView.didSelectIndexBlock = {[weak self] in
            guard let `self` = self else { return }
            self.currentSelectIndex = $1
            self.refreshData()
            self.sampleDidSelectIndexHandle?($1)
        }
        pageView.addChildVcBlock = {[weak self] in
            guard let `self` = self else { return }
            self.contentScrollViewScrollConfig($1)
        }
        
    }
 }
 
 extension LTSimpleManager: UITableViewDelegate {
    
    /*
     * 当滑动内容ScrollView的时候， 当内容contentOffset.y 大于 0（说明滑动的是内容ScrollView） 或者 当底部tableview的contentOffset.y大于 header的高度的时候，将底部tableView的偏移量设置为kHeaderHeight， 并将其他的scrollView的contentOffset置为.zero
     */
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //需要滚动到顶部 防止滚动期间下面的条件导致滚动不了
        if(isNeedScrollToTop) {
            for viewController in viewControllers {
                guard viewController.glt_scrollView != scrollView else { continue }
                viewController.glt_scrollView?.contentOffset = .zero
            }
        }else {
            delegate?.glt_scrollViewDidScroll?(scrollView)
            guard scrollView == tableView, let contentTableView = contentTableView else { return }
            let offsetY = scrollView.contentOffset.y
            if contentTableView.contentOffset.y > 0 || offsetY > kHeaderHeight - hoverY {
                tableView.contentOffset = CGPoint(x: 0.0, y: kHeaderHeight - hoverY)
            }
            if scrollView.contentOffset.y < kHeaderHeight - hoverY {
                for viewController in viewControllers {
                    guard viewController.glt_scrollView != scrollView else { continue }
                    viewController.glt_scrollView?.contentOffset = .zero
                }
            }
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.glt_scrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.glt_scrollViewWillBeginDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.glt_scrollViewDidEndDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.glt_scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.glt_scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
 }
 
 extension LTSimpleManager: UITableViewDataSource, LTTableViewProtocal {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellWithTableView(tableView)
        cell.selectionStyle = .none
        cell.contentView.addSubview(pageView)
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height
    }
 }
 
 extension LTSimpleManager {
    private func deallocConfig() {
        for viewController in viewControllers {
            viewController.glt_scrollView?.delegate = nil
        }
    }
 }
 
 
 
