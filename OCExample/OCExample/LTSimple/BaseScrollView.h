//
//  BaseScrollView.h
//  OCExample
//
//  Created by WenHao on 2021/5/14.
//  Copyright © 2021 LT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseScrollView : UIScrollView

@property (nonatomic , assign)BOOL change;

@property (nonatomic , assign)float currentY;

@end

NS_ASSUME_NONNULL_END
