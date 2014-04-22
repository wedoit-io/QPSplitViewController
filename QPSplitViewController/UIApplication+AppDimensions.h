//
//  UIApplication+AppDimensions.h
//  igamma
//
//  Created by Alessandro Zoffoli on 22/04/14.
//  Copyright (c) 2014 Apex-net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (AppDimensions)

+ (CGSize)currentSize;
+ (CGSize)sizeInOrientation:(UIInterfaceOrientation)orientation;

@end
