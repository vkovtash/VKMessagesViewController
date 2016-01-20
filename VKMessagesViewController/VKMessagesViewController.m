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


@interface VKMessagesViewController () <UIGestureRecognizerDelegate, VKMenuControllerPresenterDelegate>
@property (weak, nonatomic) UIView *keyboard;
@property (nonatomic) CGFloat originalKeyboardY;
@property (nonatomic) CGFloat originalLocation;
@property (nonatomic) NSTimeInterval keyboardAnimationDuration;
@property (nonatomic) UIViewAnimationCurve keyboardAnimationCurve;
@property (strong, nonatomic) UIGestureRecognizer *keyboardPanRecognizer;
@end

@implementation VKMessagesViewController
@synthesize messageToolbar= _messageToolbar;

#pragma mark - ViewController lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self applyTopInset];
    [self applyBottomInset];
    [self registerForKeyboardNotifications];
    
    UIView *keyboard = getKeyboardView();
    if (keyboard) {
        [self alighKeyboardControlsToRect:keyboardRectInView(keyboard, self.view) animated:animated];
    }
    
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
    [self unregisterFromKeyboardNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
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

- (void)setAlternativeInputView:(UIView *)alternativeInputView {
    _alternativeInputView = alternativeInputView;
    self.messageToolbar.isPlusButtonVisible = (BOOL)_alternativeInputView;
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
    _messageToolbar.isPlusButtonVisible = NO;
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

- (void)plusButtonPressed:(ZIMInputToolbar *)toolbar {
    if (!self.alternativeInputView) {
        return;
    }
    
    if (toolbar.textView.internalTextView != self.firstResponder) {
        toolbar.textView.inputView = self.alternativeInputView;
        [toolbar.textView becomeFirstResponder];
    }
    else {
        toolbar.textView.inputView = toolbar.textView.inputView ? nil : self.alternativeInputView;
        [toolbar.textView reloadInputViews];
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

static inline CGRect keyboardRectInViewFromKeyboardInfo(UIView *view, NSDictionary *keyboardUserInfo) {
    if (keyboardUserInfo) {
        return [view convertRect:[keyboardUserInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:view.window];
    }
    return CGRectZero;
}

- (void)registerForKeyboardNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)unregisterFromKeyboardNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [defaultCenter removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [defaultCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [defaultCenter removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    CGRect kbRect = keyboardRectInViewFromKeyboardInfo(self.view, info);
    
    if (kbRect.size.height && !self.menuPresenter.isPresentingMenu){
        self.keyboardAnimationCurve = [info[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        self.keyboardAnimationDuration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
        [self alighKeyboardControlsToRect:kbRect animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect kbRect = keyboardRectInViewFromKeyboardInfo(self.view, notification.userInfo);
    self.keyboardPanRecognizer.enabled = NO;
    if (kbRect.size.height && !self.menuPresenter.isPresentingMenu && !self.keyboard.hidden) {
        kbRect.origin.y = CGRectGetHeight(self.view.bounds);
        [self alighKeyboardControlsToRect:kbRect animated:YES];
    }
}

- (void)keyboardDidShow:(NSNotification *)notification {
    if (CGRectGetHeight(keyboardRectInViewFromKeyboardInfo(self.view, notification.userInfo)) == 0) {
        return;
    }
    
    [self catchKeyboard];
    self.menuPresenter.shouldDisplayKeyboard = YES;
    self.keyboardPanRecognizer.enabled = YES;
}

- (void)keyboardDidHide:(NSNotification *)notification {
    if (CGRectGetHeight(keyboardRectInViewFromKeyboardInfo(self.view, notification.userInfo)) == 0) {
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
        toolBarFrame.origin.y = CGRectGetMinY(rect) - CGRectGetHeight(toolBarFrame);
        weakSelf.messageToolbar.frame = toolBarFrame;
        
        [weakSelf applyBottomInset];
        [weakSelf.view layoutIfNeeded];
    };
    
    [self keyboardWillChangeFrame:rect animated:animated];
    if (animated && self.keyboardAnimationDuration > 0) {
        [UIView animateWithDuration:self.keyboardAnimationDuration
                              delay:0
                            options:animationOptionsWithCurve(self.keyboardAnimationCurve)
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
    
    [UIView animateWithDuration:self.keyboardAnimationDuration
                          delay:0
                        options:animationOptionsWithCurve(self.keyboardAnimationCurve)
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
