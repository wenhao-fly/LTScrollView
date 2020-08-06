//
//  LTTableView.swift
//  LTScrollView
//
//  Created by 高刘通 on 2017/11/14.
//  Copyright © 2017年 LT. All rights reserved.
//

import UIKit


class LTTableView: UITableView, UIGestureRecognizerDelegate {
    
    public var doubleIndexArray: NSArray = []
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            
            let superTableP = gestureRecognizer.location(in: self)
            if(superTableP.x <= 80 && (superTableP.y >  44 + 49 + 185 * self.frame.size.width/375 - self.contentOffset.y)) {
                let cells = self.visibleCells
                let content = cells.first?.contentView
                let pageView = content?.subviews.first as? LTPageView
                let scr = pageView?.subviews.first
                if scr!.isKind(of: UIScrollView.self) {
                    let scro = scr as! UIScrollView
                    let index = Int(scro.contentOffset.x)/375 as Int
                    if doubleIndexArray.contains(String(index)) {
                        self.isScrollEnabled = false
                        return false
                    }
                }
                return true
            }else{
                return true
            }
        }
        
        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
    }
}
