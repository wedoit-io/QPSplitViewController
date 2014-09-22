//
//  QPSplitViewController.h
//  Example
//
//  Created by QuangPC on 3/31/14.
//  Copyright (c) 2014 quangpc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QPSplitViewController : UIViewController

- (instancetype)initWithLeftViewController:(UIViewController *)leftController rightViewController:(UIViewController *)rightController;

@property (strong, nonatomic) UIViewController *leftController;

@property (strong, nonatomic) UIViewController *rightController;

@property (assign, nonatomic, setter = setLeftSplitWidth:) CGFloat leftSplitWidth;

@property (assign, nonatomic, setter = setRightSplitWidth:) CGFloat rightSplitWidth;

@end


#pragma mark -
#pragma mark UIViewController Category

@interface UIViewController (QPSplitViewController)

- (QPSplitViewController *)qp_splitViewController;

@end