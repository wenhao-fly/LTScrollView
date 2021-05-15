//
//  LTTableView.swift
//  LTScrollView
//
//  Created by 高刘通 on 2017/11/14.
//  Copyright © 2017年 LT. All rights reserved.
//

import UIKit


class LTTableView: UITableView, UIGestureRecognizerDelegate {
    
    public var iss: Bool = false
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print(111)
        return iss
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        self.isScrollEnabled = true
        
        let cells = self.visibleCells
        print(111)
        if cells.count == 1 {
            let content = cells.first?.contentView
            let pageView = content?.subviews.first as? LTPageView
            let scr = pageView?.subviews.first
            if scr!.isKind(of: UIScrollView.self) {
                guard let point = scr?.convert(point, from: self) else { return nil }
                
                if((scr?.layer.contains(point)) != nil) {
                    iss = true
                }else{
                    iss = false
                }
            }
        }
        
        return hitView
    }
}
