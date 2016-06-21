//
//  VKMessagesViewController.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKMessagesViewController.h"
#import "UIViewController+firstResponder.h"
#import "VKBubbleCell.h"
#import "ZIMKeyboardTracker.h"


static CGFloat const kDefaultToolbarHeight = 40;
static CGFloat const kDefaultToolbarPortraitMaximumHeight = 195;
static CGFloat const kDefaultToolbarLandscapeMaximumHeight = 101;


UIView* getKeyboardView() { //Should be called when keyboard is on the screen
    //Because we cant get access to the UIKeyboard throught the SDK we will just use UIView.
    //UIKeyboard is a subclass of UIView anyways
    //see discussion http://www.iphonedevsdk.com/forum/iphone-sdk-development/6573-howto-customize-uikeyboard.html
    
    static NSString *const ios8KeyboardContainerClassName = @"UIInputSetContainerView";
    static NSString *const preIos8KeyboardClassName = @"UIPeripheralHostView";
    
    __block UIView *keyboardView = nil;
    
    void(^viewsEnumerationBlock)(UIView *view, NSUInteger idx, BOOL *stop) = ^(UIView *view, NSUInteger idx, BOOL *stop) {
        NSString *viewClassName = NSStringFromClass([view class]);
        if ([viewClassName isEqualToString:ios8KeyboardContainerClassName]) {
            keyboardView = [view.subviews firstObject];
        }
        else if ([viewClassName isEqualToString:preIos8KeyboardClassName]) {
            keyboardView = view;
        }
        
        *stop = (keyboardView != nil);
    };
    
    NSArray *appWindows = [[UIApplication sharedApplication].windows copy];
    [appWindows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
        NSArray *views = [window.subviews copy];
        [views enumerateObjectsUsingBlock:viewsEnumerationBlock];
        *stop = (keyboardView != nil);
    }];
    
    return keyboardView;
};


static inline CGRect keyboardRectInView(UIView *keyboard, UIView *view) {
    if (keyboard && view) {
        return [view convertRect:keyboard.frame fromView:view.window];
    }
    return CGRectZero;
}


@interface VKMessagesViewController () <UIGestureRecognizerDelegate, VKMenuControllerPresenterDelegate, ZIMKeyboardTrackerDelegate>
@property (weak, nonatomic) UIView *keyboard;
@property (nonatomic) CGFloat originalKeyboardY;
@property (nonatomic) CGFloat originalLocation;
@property (strong, nonatomic) UIGestureRecognizer *keyboardPanRecognizer;
@property (strong, nonatomic) ZIMKeyboardTracker *keyboardTracker;
@end

@implementation VKMessagesViewController
@synthesize messageToolbar= _messageToolbar;

#pragma mark - ViewController lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self applyTopInset];
    [self applyBottomInset];

    [self alighKeyboardControlsToRect:[self.keyboardTracker keyboardRectInView:self.view] animated:animated];

    [self onAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self restoreKeyboard];
    [self onDisappear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self dismissKeyboard];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    self.keyboardTracker = [ZIMKeyboardTracker new];
    
    /* Set Table View properties */
    self.tableView = [[VKTableView alloc] initWithFrame:self.view.bounds];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.messageToolbar];
    
    self.messagePlaceholder = @"Message";
    [self setAppropriateInputHeight];
    [self applyBottomInset];
    // Scroll table to bottom cell
    [self scrollTableViewToBottomAnimated:NO];
    
    //Message copying
    UILongPressGestureRecognizer *longPressRecognizer =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
    [self.tableView addGestureRecognizer:longPressRecognizer];
    
    self.keyboardPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    self.keyboardPanRecognizer.delegate = self;
    self.keyboardPanRecognizer.enabled = NO;
    [self.view addGestureRecognizer:self.keyboardPanRecognizer];

    self.keyboardTracker.delegate = self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
    [self setAppropriateInputHeight];
}

- (void)viewDidLayoutSubviews {
    [self applyTopInset];
}

#pragma mark - Public properties

- (NSString *)messagePlaceholder {
    return self.messageToolbar.textView.placeholder;
}

- (void)setMessagePlaceholder:(NSString *)messagePlaceholder {
    self.messageToolbar.textView.placeholder = messagePlaceholder;
}

- (VKMenuControllerPresenter *)menuPresenter {
    if (!_menuPresenter) {
        _menuPresenter = [[VKMenuControllerPresenter alloc] initWithParentView:self.view];
    }
    return _menuPresenter;
}

- (ZIMInputToolbar *)messageToolbar {
    if (_messageToolbar) {
        return _messageToolbar;
    }
    
    CGRect toolbarFrame = CGRectMake(0,
                                     CGRectGetHeight(self.view.bounds) - kDefaultToolbarHeight,
                                     CGRectGetWidth(self.view.bounds),
                                     kDefaultToolbarHeight);
    _messageToolbar = [[ZIMInputToolbar alloc] initWithFrame:toolbarFrame];
    _messageToolbar.inputDelegate = self;
    _messageToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    return _messageToolbar;
}

- (CGFloat)topInset {
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    CGRect navigationBarRect = [self.view convertRect:navigationBar.bounds fromView:navigationBar];
    return CGRectGetMaxY(navigationBarRect);
}

- (CGFloat)bottomInset {
    return CGRectGetHeight(self.view.bounds) - CGRectGetMinY(self.messageToolbar.frame);
}

- (CGFloat)keyboardPullDownThresholdOffset {
    return CGRectGetHeight(self.messageToolbar.bounds);
}

#pragma mark - Public methods

- (void)onAppear {
    [self.tableView reloadData];
    [self scrollTableViewToBottomAnimated:NO];
}

- (void)onDisappear {
    
}

- (void)applyBottomInset {
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom = self.bottomInset;
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
}

- (void)applyTopInset {
    UIEdgeInsets inset = self.tableView.contentInset;
    inset.top = self.topInset;
    self.tableView.contentInset = inset;
    self.tableView.scrollIndicatorInsets = inset;
}

- (void)scrollTableViewToBottomAnimated:(BOOL)animated {
    [self.tableView scrollToBottomAnimated:animated];
}

- (void)dismissKeyboard {
    [self.messageToolbar.textView resignFirstResponder];
}

- (void)performAction:(SEL)action withSender:(id)sender userInfo:(NSDictionary *)userInfo {
    [self performAction:action forRowAtIndexPath:userInfo[@"cellIndexPath"] withSender:sender];
}

- (BOOL)shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return NO;
}

- (void)performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
}

#pragma mark - Private methods

- (void)setAppropriateInputHeight {
    CGFloat height = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? kDefaultToolbarPortraitMaximumHeight:
                                                                                   kDefaultToolbarLandscapeMaximumHeight;
    self.messageToolbar.textView.maximumHeight = height;
}

- (void)longPressRecognized:(UIGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan || self.menuPresenter.isPresentingMenu) {
        return;
    }
    
    CGPoint point = [recognizer locationInView:self.tableView];
    NSIndexPath *cellIndex = [self.tableView indexPathForRowAtPoint:point];
    
    if (!cellIndex) {
        return;
    }
    
    if (![self shouldShowMenuForRowAtIndexPath:cellIndex]) {
        return;
    }
    
    VKBubbleCell *cell = (VKBubbleCell *)[self.tableView cellForRowAtIndexPath:cellIndex];
    
    [cell setSelected:YES];
    [self.menuPresenter showDefaultMenuWithResponder:self
                                            userInfo:@{@"cellIndexPath":cellIndex}
                                              inView:cell.bubbleView
                                       returnFocusTo:self.firstResponder
                                           menuItems:self.cellMenuItems
                                          completeon:^{
                                              [cell setSelected:NO];
                                          }];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender userInfo:(NSDictionary *)userInfo {
    return [self canPerformAction:action forRowAtIndexPath:userInfo[@"cellIndexPath"] withSender:sender];
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UIInputToolbarDelegate

-(void)inputButtonPressed:(ZIMInputToolbar *)toolbar {
    if (toolbar.textView.text.length > 0) {
        toolbar.textView.text = @"";
    }
}

- (void)inputToolbar:(ZIMInputToolbar *)inputToolbar didChangeHeight:(CGFloat)height {
    [self applyBottomInset];
    [self.view layoutIfNeeded];
}

- (void)inputToolbarDidBeginEditing:(ZIMInputToolbar *)inputToolbar {
    if (!self.menuPresenter.isPresentingMenu) { //Scroll down only when keyboard was hidden
        [self scrollTableViewToBottomAnimated:YES];
    }
}

#pragma mark - Keyboard Notifications

static inline UIViewAnimationOptions animationOptionsWithCurve(UIViewAnimationCurve curve) {
    return curve << 16;
}

static inline CGRect keyboardRectInViewFromKeyboardFrame(UIView *view, CGRect keyboardFrame) {
    return [view convertRect:keyboardFrame fromView:view.window];
}

- (void)trackerDetectedKeyboardWillShow:(ZIMKeyboardTracker *)tracker {
    CGRect kbRect = keyboardRectInViewFromKeyboardFrame(self.view, tracker.keyboardFrame);
    if (kbRect.size.height && !self.menuPresenter.isPresentingMenu){
        [self alighKeyboardControlsToRect:kbRect animated:YES];
    }
}

- (void)trackerDetectedKeyboardWillHide:(ZIMKeyboardTracker *)tracker {
    self.keyboardPanRecognizer.enabled = NO;

    CGRect kbRect = keyboardRectInViewFromKeyboardFrame(self.view, tracker.keyboardFrame);
    if (kbRect.size.height && !self.menuPresenter.isPresentingMenu){
        [self alighKeyboardControlsToRect:kbRect animated:YES];
    }
}

- (void)trackerDetectedKeyboardDidShow:(ZIMKeyboardTracker *)tracker {
    CGRect kbRect = keyboardRectInViewFromKeyboardFrame(self.view, tracker.keyboardFrame);
    if (CGRectGetHeight(kbRect) == 0) {
        return;
    }
    
    [self catchKeyboard];
    self.menuPresenter.shouldDisplayKeyboard = YES;
    self.keyboardPanRecognizer.enabled = YES;
}

- (void)trackerDetectedKeyboardDidHide:(ZIMKeyboardTracker *)tracker {
    CGRect kbRect = keyboardRectInViewFromKeyboardFrame(self.view, tracker.keyboardFrame);

    if (CGRectGetHeight(kbRect) == 0) {
        return;
    }

    self.menuPresenter.shouldDisplayKeyboard = NO;
    self.keyboard.hidden = NO;
}

- (void)keyboardWillChangeFrame:(CGRect)frame animated:(BOOL)animated {
    
}

#pragma mark - Keyboard control

- (void)catchKeyboard {
    if (!self.keyboard) {
        self.keyboard = getKeyboardView();
    }
}

- (void)alighKeyboardControlsToRect:(CGRect)rect animated:(BOOL)animated {
    __weak __typeof(&*self) weakSelf = self;
    void (^alignControlsToRect)()  = ^{
        if (!weakSelf) {
            return;
        }
        
        CGRect toolBarFrame = weakSelf.messageToolbar.frame;
        if (weakSelf.keyboardTracker.isKeyboardHidden) {
            toolBarFrame.origin.y = CGRectGetMaxY(weakSelf.view.bounds) - CGRectGetHeight(toolBarFrame);
        }
        else {
            toolBarFrame.origin.y = MIN(CGRectGetMinY(rect), CGRectGetMaxY(weakSelf.view.bounds)) - CGRectGetHeight(toolBarFrame);
        }
        weakSelf.messageToolbar.frame = toolBarFrame;
        
        [weakSelf applyBottomInset];
        [weakSelf.view layoutIfNeeded];
    };
    
    [self keyboardWillChangeFrame:rect animated:animated];
    if (animated && self.keyboardTracker.lastAnimationDuration > 0) {
        [UIView animateWithDuration:self.keyboardTracker.lastAnimationDuration
                              delay:0
                            options:animationOptionsWithCurve(self.keyboardTracker.lastAnimationCurve)
                         animations:alignControlsToRect
                         completion:nil];
    }
    else {
        alignControlsToRect();
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self.view];
    CGPoint velocity = [gestureRecognizer velocityInView:self.view];
    CGFloat spaceAboveKeyboard =
        CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.keyboard.frame) - self.keyboardPullDownThresholdOffset;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.originalKeyboardY = CGRectGetMinY(self.keyboard.frame);
            self.keyboard.userInteractionEnabled = NO;
            break;
            
        case UIGestureRecognizerStateEnded:
            if (velocity.y > 0 && location.y > spaceAboveKeyboard) {
                [self animateKeyboardOffscreen];
            }
            else {
                [self animateKeyboardReturnToOriginalPosition];
            }
            self.keyboard.userInteractionEnabled = YES;
            self.tableView.panGestureRecognizer.enabled = YES;
            break;
            
        case UIGestureRecognizerStateChanged:
            if (location.y > spaceAboveKeyboard) {
                self.tableView.panGestureRecognizer.enabled = NO;
                CGRect newFrame = self.keyboard.frame;
                CGFloat newY = self.originalKeyboardY + (location.y - spaceAboveKeyboard);
                newY = MAX(newY, self.originalKeyboardY);
                newFrame.origin.y = newY;
                [self.keyboard setFrame:newFrame];
                [self alighKeyboardControlsToRect:keyboardRectInView(self.keyboard, self.view) animated:NO];
            }
            break;
            
        default:
            break;
    }
}

- (void)animateKeyboardOffscreen {
    CGRect newFrame = self.keyboard.frame;
    newFrame.origin.y = CGRectGetHeight(self.keyboard.superview.bounds);
    self.keyboardPanRecognizer.enabled = NO;
    
    [UIView animateWithDuration:self.keyboardTracker.lastAnimationDuration
                          delay:0
                        options:animationOptionsWithCurve(self.keyboardTracker.lastAnimationCurve)
                     animations:^
    {
        [self.keyboard setFrame:newFrame];
        [self alighKeyboardControlsToRect:keyboardRectInView(self.keyboard, self.view) animated:NO];
    } completion:^(BOOL finished) {
        // To remove the animation for the keyboard dropping showing
        // we have to hide the keyboard, and on will show we set it back.
        self.keyboard.hidden = YES;
        [self.messageToolbar.textView resignFirstResponder];
    }];
}

- (void)animateKeyboardReturnToOriginalPosition {
    CGRect newFrame = self.keyboard.frame;
    newFrame.origin.y = self.originalKeyboardY;
    
    if (CGRectEqualToRect(newFrame, self.keyboard.frame)) {
        return;
    }
    
    [UIView beginAnimations:nil context:NULL];
    self.keyboard.frame = newFrame;
    [self alighKeyboardControlsToRect:keyboardRectInView(self.keyboard, self.view) animated:NO];
    [UIView commitAnimations];
}

- (void)restoreKeyboard {
    self.keyboard.userInteractionEnabled = YES;
    self.keyboard.hidden = NO;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return (gestureRecognizer == self.keyboardPanRecognizer || otherGestureRecognizer == self.keyboardPanRecognizer);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer != self.keyboardPanRecognizer) {
        return YES;
    }
    
    // Don't allow panning if inside the active input (unless SELF is a UITextView and the receiving view)
    return (![touch.view isFirstResponder] || ([self isKindOfClass:[UITextView class]] && [self isEqual:touch.view]));
}

@end
