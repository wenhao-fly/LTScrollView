//
//  LTSimpleManagerDemo.swift
//  LTScrollView
//
//  Created by 高刘通 on 2018/2/3.
//  Copyright © 2018年 LT. All rights reserved.
//
//  如有疑问，欢迎联系本人QQ: 1282990794
//
//  ScrollView嵌套ScrolloView解决方案（初级、进阶)， 支持OC/Swift
//
//  github地址: https://github.com/gltwy/LTScrollView
//
//  clone地址:  https://github.com/gltwy/LTScrollView.git
//
//private let glt_iphoneX = (UIScreen.main.bounds.height >= 812.0)

import UIKit
import MJRefresh

class LTSimpleManagerDemo: UIViewController {
    
    private lazy var titles: [String] = {
//        return ["全部(30)", "回放"]
        return ["热门", "精彩推荐科技控科技控", "主旨报告", "科技控", "游戏", "精彩推荐", "科技控", "精彩推荐", "科技控"]
    }()
    
    private lazy var viewControllers: [UIViewController] = {
        var vcs = [UIViewController]()
        for _ in titles {
            vcs.append(LTSimpleTestOneVC())
        }
        return vcs
    }()
    
    private lazy var layout: LTLayout = {
        let layout = LTLayout()
        layout.bottomLineHeight = 4.0
        layout.bottomLineCornerRadius = 2.0
//        layout.isHiddenSlider = true
        /* 更多属性设置请参考 LTLayout 中 public 属性说明 */
        layout.titleFont = UIFont.systemFont(ofSize: 15)
        layout.lrMargin = 15
        layout.titleMargin = 15
        layout.sliderWidth = 22
        
        layout.isNeedScale = true;
        layout.isAverage = false
//        layout.hasCorner = true  //圆角
//        layout.cornerBgColor = UIColor.gray
//        layout.cornerSelectBgColor = UIColor.cyan
        return layout
    }()
    
    private func managerReact() -> CGRect {
        let statusBarH = UIApplication.shared.statusBarFrame.size.height
        let Y: CGFloat = statusBarH + 44
        let H: CGFloat = glt_iphoneX ? (view.bounds.height - Y - 34) : view.bounds.height - Y
        return CGRect(x: 0, y: Y, width: view.bounds.width, height: H)
    }
    
    /*
    // 取消注释此处为自定义titleView
     private lazy var simpleManager: LTSimpleManager = {
     let customTitleView = LTCustomTitleView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44), titles: titles, layout: layout)
     customTitleView.isCustomTitleView = true
     let simpleManager = LTSimpleManager(frame: managerReact(), viewControllers: viewControllers, titles: titles, currentViewController: self, layout: layout, titleView: customTitleView)
     /* 设置代理 监听滚动 */
     simpleManager.delegate = self
     return simpleManager
     }()
    */
 
    

    private lazy var simpleManager: LTSimpleManager = {
        let simpleManager = LTSimpleManager(frame: managerReact(), viewControllers: viewControllers, titles: titles, currentViewController: self, layout: layout)
        /* 设置代理 监听滚动 */
        simpleManager.delegate = self
        return simpleManager
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        view.addSubview(simpleManager)
        simpleManagerConfig()
        
        //获取所以titles 加角标
        let button = simpleManager.pageView.glt_buttons.first
        button?.setTitle("123", for: .normal)
        
        //编辑时 禁止滑动
//        simpleManager.pageView.scrollView.isScrollEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("LTSimpleManagerDemo < --> deinit")
    }
}


extension LTSimpleManagerDemo {
    
    //MARK: 具体使用请参考以下
    private func simpleManagerConfig() {
        
        //MARK: headerView设置
        simpleManager.configHeaderView {[weak self] in
            guard let strongSelf = self else { return nil }
            let headerView = strongSelf.testLabel()
            return headerView
        }
        
        //MARK: pageView点击事件
        simpleManager.didSelectIndexHandle { [weak self] (index) in
            print("点击了 \(index) 😆")
            
        }
        
    }
    
    @objc private func tapLabel(_ gesture: UITapGestureRecognizer)  {
        print("tapLabel☄")
    }
}

extension LTSimpleManagerDemo: LTSimpleScrollViewDelegate {
    
    //MARK: 滚动代理方法
    func glt_scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("offset -> ", scrollView.contentOffset.y)
    }
    
    //MARK: 控制器刷新事件代理方法
    func glt_refreshScrollView(_ scrollView: UIScrollView, _ index: Int) {
        //注意这里循环引用问题。
        scrollView.mj_header = MJRefreshNormalHeader {[weak scrollView] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                print("对应控制器的刷新自己玩吧，这里就不做处理了🙂-----\(index)")
                scrollView?.mj_header.endRefreshing()
                
                self.simpleManager.pageView.changeTitlesWithArray(titles: ["刷新","大叔","大大婶","大健康"])
            })
        }
    }
}

extension LTSimpleManagerDemo {
    private func testLabel() -> UIView {
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 180))
        
        let s = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 180))
        s.contentSize = CGSize(width: 700, height: 180)
        let c = UIView(frame: CGRect(x: 0, y: 10, width: self.view.bounds.width, height: 160))
        c.backgroundColor = UIColor.cyan
        s.addSubview(c)
        bgView.addSubview(s)
        
        return bgView
    }
}

