//
//  QPSplitView.h
//  Example
//
//  Created by QuangPC on 3/31/14.
//  Copyright (c) 2014 quangpc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QPSplitViewController;

@interface QPSplitView : UIView

@property (strong, nonatomic) UIView *leftView;

@property (strong, nonatomic) UIView *rightView;

- (instancetype)initWithFrame:(CGRect)frame controller:(QPSplitViewController *)splitController;

- (void)setLeftSplitWidth:(CGFloat)width;

- (void)setRightSplitWidth:(CGFloat)width;

@end
