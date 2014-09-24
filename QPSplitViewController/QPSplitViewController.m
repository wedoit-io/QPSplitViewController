//
//  QPSplitViewController.m
//  Example
//
//  Created by QuangPC on 3/31/14.
//  Copyright (c) 2014 quangpc. All rights reserved.
//

#import "QPSplitViewController.h"
#import "QPSplitView.h"
#import "UIApplication+AppDimensions.h"

@interface QPSplitViewController ()

@property (assign, nonatomic) CGFloat actualLeftSplitWidth;
@property (strong, nonatomic) QPSplitView *splitView;

@end

@implementation QPSplitViewController

- (instancetype)initWithLeftViewController:(UIViewController *)leftController
                       rightViewController:(UIViewController *)rightController {
    self = [super init];
    if (self) {
        CGRect frame = [[UIScreen mainScreen] bounds];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            // on iphone, default left width is set equal the width of the
            // screen when in portrait
            _leftSplitWidth =  MIN(frame.size.width, frame.size.height);
        } else {
            _leftSplitWidth = 260.0f;
        }
        
        _actualLeftSplitWidth = _leftSplitWidth;
        
        _rightSplitWidth = frame.size.width - _leftSplitWidth;
        _splitView = [[QPSplitView alloc] initWithFrame:frame controller:self];
        _splitView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self initLeftViewController:leftController];
        [self initRightViewController:rightController];
    }
    return self;
}

- (instancetype)init {
    return [self initWithLeftViewController:nil rightViewController:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadView {
    self.view = _splitView;
    _splitView.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateActualLeftSplitWidthTogglingLeftSplit:NO];
}

#pragma mark -
#pragma mark Set Controllers methods

- (void)setLeftController:(UIViewController *)leftController {
    [self setLeftController:leftController animated:NO];
}

- (void)setLeftController:(UIViewController *)leftController animated:(BOOL)animated {
    if (![self isViewLoaded]) {
        [self initLeftViewController:leftController];
        return;
    }
    if (leftController == _leftController) {
        return;
    }
    [self changeLeftViewController:leftController];
}

- (void)setRightController:(UIViewController *)rightController {
    [self setRightController:rightController animated:NO];
}

- (void)setRightController:(UIViewController *)rightController animated:(BOOL)animated {
    if (![self isViewLoaded]) {
        [self initRightViewController:rightController];
        return;
    }
    if (rightController == _rightController) {
        return;
    }
    [self changeRightViewController:rightController];
}

#pragma mark -
#pragma mark - Transition between controllers

- (void)initLeftViewController:(UIViewController *)leftController {
    if (leftController) {
        [self addChildViewController:leftController];
        leftController.view.frame = _splitView.leftView.bounds;
        [_splitView.leftView addSubview:leftController.view];
        [leftController didMoveToParentViewController:self];
        _leftController = leftController;
    }
    
}

- (void)initRightViewController:(UIViewController *)rightController {
    if (rightController) {
        [self addChildViewController:rightController];
        rightController.view.frame = _splitView.rightView.bounds;
        [_splitView.rightView addSubview:rightController.view];
        [rightController didMoveToParentViewController:self];
        _rightController = rightController;
        
        [self setLeftBarButtonItem];
        [self addTapGestureToRightSplit];
    }
}

- (void)changeLeftViewController:(UIViewController *)leftController{
    UIViewController *oldController = _leftController;
    [oldController willMoveToParentViewController:nil];
    [oldController.view removeFromSuperview];
    [oldController removeFromParentViewController];
    
    leftController.view.frame = _splitView.leftView.bounds;
    [self changeNewLeftController:leftController];
}

- (void)changeNewLeftController:(UIViewController *)newLeftController {
    [self addChildViewController:newLeftController];
    [_splitView.leftView addSubview:newLeftController.view];
    [newLeftController didMoveToParentViewController:self];
    _leftController = newLeftController;
}

- (void)changeRightViewController:(UIViewController *)rightController{
    UIViewController *oldController = _rightController;
    for (UIGestureRecognizer *recognizer in oldController.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:recognizer];
    }
    [oldController willMoveToParentViewController:nil];
    [oldController.view removeFromSuperview];
    [oldController removeFromParentViewController];
    
    rightController.view.frame = _splitView.rightView.bounds;
    [self changeNewRightController:rightController];
}

- (void)changeNewRightController:(UIViewController *)newRightController {
    [self addChildViewController:newRightController];
    [_splitView.rightView addSubview:newRightController.view];
    [newRightController didMoveToParentViewController:self];
    _rightController = newRightController;
    
    [self setLeftBarButtonItem];
    [self addTapGestureToRightSplit];
}

#pragma mark -
#pragma mark Left bar button item for right panel

- (UIBarButtonItem *)leftButtonForCenterPanel {
    return [[UIBarButtonItem alloc] initWithImage:[[self class] defaultImage]
                                            style:UIBarButtonItemStylePlain
                                           target:self
                                           action:@selector(toggleLeftSplit:)];
}

+ (UIImage *)defaultImage {
    static UIImage *defaultImage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.f, 13.f), NO, 0.0f);
        
        [[UIColor whiteColor] setFill];
        [[UIBezierPath bezierPathWithRect:CGRectMake(0, 1, 20, 2)] fill];
        [[UIBezierPath bezierPathWithRect:CGRectMake(0, 6,  20, 2)] fill];
        [[UIBezierPath bezierPathWithRect:CGRectMake(0, 11, 20, 2)] fill];
        
        defaultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    });
    return defaultImage;
}

- (void)setLeftBarButtonItem {
    if ([_rightController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navCtrl = (UINavigationController *)_rightController;
        navCtrl.topViewController.navigationItem.leftBarButtonItem = [self leftButtonForCenterPanel];
    }
}

- (void)toggleLeftSplit:(id)sender {
    if (self.actualLeftSplitWidth == 0) {
        [self showLeftSplit];
    } else {
        [self showRightSplitFullscreen];
    }
}

- (void)showLeftSplit {
    [UIView animateWithDuration:0.2f animations:^{
        [self updateActualLeftSplitWidthTogglingLeftSplit:YES];
        self.leftController.view.alpha = 1.0f;
    }];
}

- (void)showRightSplitFullscreen {
    [UIView animateWithDuration:0.2f animations:^{
        [self updateActualLeftSplitWidthTogglingLeftSplit:YES];
        self.leftController.view.alpha = 0.0f;
    }];
}

#pragma mark -
#pragma mark UISwipeGestureRecognizer

- (void)addTapGestureToRightSplit {
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(swipedLeft:)];
    leftSwipeGesture.direction = (UISwipeGestureRecognizerDirectionLeft);
    
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(swipedRight:)];
    rightSwipeGesture.direction = (UISwipeGestureRecognizerDirectionRight);
    
    [self.rightController.view addGestureRecognizer:leftSwipeGesture];
    [self.rightController.view addGestureRecognizer:rightSwipeGesture];
}

#pragma mark -
#pragma mark UISwipeGestureRecognizer events

- (void)swipedRight:(UISwipeGestureRecognizer *)recognizer {
    if (self.leftSplitWidth == 0) [self showLeftSplit];
}

- (void)swipedLeft:(UISwipeGestureRecognizer *)recognizer {
    if (self.leftSplitWidth > 0) [self showRightSplitFullscreen];
}

#pragma mark -
#pragma mark Change Width

- (void)setLeftSplitWidth:(CGFloat)leftSplitWidth {
    _leftSplitWidth = leftSplitWidth;
    [self updateActualLeftSplitWidthTogglingLeftSplit:NO];
}

- (void)updateActualLeftSplitWidthTogglingLeftSplit:(BOOL)toggleLeftSplit {
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGFloat iphoneFullScreenWidth = MIN(frame.size.width, frame.size.height);
    
    if (toggleLeftSplit) {
        if (self.actualLeftSplitWidth == 0) {
            // expand left split
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
                if(UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
                    // on iphone-portrait, expand to fullscreen
                    self.actualLeftSplitWidth = iphoneFullScreenWidth;
                } else if (MAX(frame.size.width, frame.size.height) < 568) {
                    // in landscape-iphone with 'small' screen, expand left split to fullscreen
                    self.actualLeftSplitWidth = MAX(frame.size.width, frame.size.height);
                } else {
                    // expand to left split width value
                    self.actualLeftSplitWidth = self.leftSplitWidth;
                }
            } else {
                // expand to left split width value
                self.actualLeftSplitWidth = self.leftSplitWidth;
            }
        } else {
            // hide left split
            self.actualLeftSplitWidth = 0;
        }
        
        // expand/compress!
        [_splitView setLeftSplitWidth:self.actualLeftSplitWidth];
    } else {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
                // iphone-portrait
                if (self.actualLeftSplitWidth != 0) {
                    // if actual left split width is != 0 and the device is in
                    // phone-portrait, it means that we need to expand to fullscreen
                    self.actualLeftSplitWidth = iphoneFullScreenWidth;
                    [_splitView setLeftSplitWidth:self.actualLeftSplitWidth];
                } else {
                    // right split is fullscreen, left is compressed, nothing to do
                }
            } else {
                if (self.actualLeftSplitWidth != 0 && MAX(frame.size.width, frame.size.height) < 568) {
                    // in landscape-iphone with 'small' screen, expand left split to fullscreen
                    self.actualLeftSplitWidth = MAX(frame.size.width, frame.size.height);
                    [_splitView setLeftSplitWidth:self.actualLeftSplitWidth];
                } else if (self.actualLeftSplitWidth != 0) {
                    // if actual left split width is != 0 and the device is in
                    // phone-landscape, it means that we need to expand to left split width
                    self.actualLeftSplitWidth = self.leftSplitWidth;
                    [_splitView setLeftSplitWidth:self.actualLeftSplitWidth];
                } else {
                    // right split is fullscreen, left is compressed, nothing to do
                }
            }
        } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            // nothing to do
        }
    }
    
}

- (void)setRightSplitWidth:(CGFloat)rightSplitWidth {
    [_splitView setRightSplitWidth:rightSplitWidth];
    _rightSplitWidth = rightSplitWidth;
}

#pragma mark - Rotation Support

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self updateActualLeftSplitWidthTogglingLeftSplit:NO];
}

@end

#pragma mark -
#pragma mark UIViewController Category

@implementation UIViewController (QPSplitViewController)

- (QPSplitViewController *)qp_splitViewController {
    UIViewController *parent = self;
    Class revealClass = [QPSplitViewController class];
    
    while (nil != (parent = [parent parentViewController]) &&
           ![parent isKindOfClass:revealClass] ){}
    
    return (id)parent;
}

@end
