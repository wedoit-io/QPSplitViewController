//
//  QPSplitView.m
//  Example
//
//  Created by QuangPC on 3/31/14.
//  Copyright (c) 2014 quangpc. All rights reserved.
//

#import "QPSplitView.h"
#import "QPSplitViewController.h"

@interface QPSplitView ()
{
    
}
@property (weak, nonatomic) QPSplitViewController *splitController;
@end

@implementation QPSplitView

- (instancetype)initWithFrame:(CGRect)frame controller:(QPSplitViewController *)splitController {
    self = [super initWithFrame:frame];
    if (self) {
        _splitController = splitController;
        CGRect bounds = self.bounds;
        _leftView = [[UIView alloc] initWithFrame:bounds];
        _leftView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self addSubview:_leftView];
        
        _rightView = [[UIView alloc] initWithFrame:bounds];
        _rightView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_rightView];
        
        // default 260 left size
        [self setLeftSplitWidth:_splitController.leftSplitWidth];
    }
    return self;
}

- (void)setLeftSplitWidth:(CGFloat)width {
    CGRect bounds = self.bounds;
    
    CGRect leftFrame = _leftView.frame;
    leftFrame.origin.x = 0;
    leftFrame.size.width = width;
    _leftView.frame = leftFrame;
    
    // change right
    CGRect rightFrame = _rightView.frame;
    rightFrame.origin.x = width;
    rightFrame.size.width = bounds.size.width - width;
    _rightView.frame = rightFrame;
}

- (void)setRightSplitWidth:(CGFloat)width {
    CGRect bounds = self.bounds;
    
    CGRect rightFrame = _rightView.frame;
    rightFrame.size.width = width;
    rightFrame.origin.x = bounds.size.width - width;
    _rightView.frame = rightFrame;
    
    CGRect leftFrame = _leftView.frame;
    leftFrame.origin.x = 0;
    leftFrame.size.width = bounds.size.width - width;
    _leftView.frame = leftFrame;
}
@end
