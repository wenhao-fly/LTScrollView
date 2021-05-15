//
//  BaseScrollView.m
//  OCExample
//
//  Created by WenHao on 2021/5/14.
//  Copyright © 2021 LT. All rights reserved.
//

#import "BaseScrollView.h"

@implementation BaseScrollView {

    
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if([super initWithFrame:frame]){
        
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0) {
    if(!_change){
//        NSLog(@"不能动");
        return true; //tableview不响应
    }else{
        return false;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0){
    if(_change){
//        NSLog(@"不能动");
        return true; //tableview不响应
    }else{
        return false;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    NSLog(@"%.2f ",fabs([self.panGestureRecognizer translationInView:self].y));
    
    if(fabs([self.panGestureRecognizer translationInView:self].y) > fabs([self.panGestureRecognizer translationInView:self].x)) {
//        NSLog(@"上下1111111111111111111");
        _change = true;
    }else{
        if(_currentY != fabs([self.panGestureRecognizer translationInView:self].y)) {
            NSLog(@"2");
            _change = true;
        }else{
            NSLog(@"3333333333");
            _change = false;
            _currentY = fabs([self.panGestureRecognizer translationInView:self].y);
        }
    }
    
    return false;
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    NSLog(@"3333");
//    _change = false;
//    return [super hitTest:point withEvent:event];
//}

@end
