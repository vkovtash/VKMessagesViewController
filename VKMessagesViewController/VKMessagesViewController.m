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

@interface VKMessagesViewController () <UIGestureRecognizerDelegate, VKMenuControllerPresenterDelegate>
@property (weak, nonatomic) UIView *keyboard;
@property (nonatomic) CGFloat originalKeyboardY;
@property (nonatomic) CGFloat originalLocation;
@property (nonatomic) NSTimeInterval keyboardAnimationDuration;
@property (nonatomic) UIViewAnimationCurve keyboardAnimationCurve;
@property (strong, nonatomic) UIGestureRecognizer *keyboardPanRecognizer;
@end

@implementation VKMessagesViewController

#pragma mark - Publick properties

- (NSString *) messagePlaceholder{
    return self.messageToolbar.textView.placeholder;
}

- (void) setMessagePlaceholder:(NSString *)messagePlaceholder{
    self.messageToolbar.textView.placeholder = messagePlaceholder;
}

- (void) setAlternativeInputView:(UIView *)alternativeInputView {
    _alternativeInputView = alternativeInputView;
    self.messageToolbar.isPlusButtonVisible = (BOOL)_alternativeInputView;
}

- (VKMenuControllerPresenter *) menuPresenter {
    if (!_menuPresenter) {
        _menuPresenter = [[VKMenuControllerPresenter alloc] initWithParentView:self.view];
    }
    return _menuPresenter;
}

#pragma mark - ViewController lifecycle

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self scrollTableViewToBottomAnimated:NO];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self restoreKeyboard];
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];    
    // Register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    /* Create toolbar */
    self.messageToolbar = [[ZIMInputToolbar alloc] initWithFrame:CGRectMake(0,
                                                                            self.view.frame.size.height - kDefaultToolbarHeight,
                                                                            self.view.frame.size.width,
                                                                            kDefaultToolbarHeight)];
    self.messageToolbar.inputDelegate = self;
    self.messageToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    self.messageToolbar.isPlusButtonVisible = NO;
    self.messagePlaceholder = @"Message";
    [self setAppropriateInputHeight];
    
    /* Set Table View properties */
    self.tableView = [[VKTableView alloc] initWithFrame:self.view.bounds];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.messageToolbar];
    [self inputToolbar:self.messageToolbar didChangeHeight:self.messageToolbar.frame.size.height];
    
    // Scroll table to bottom cell
    [self scrollTableViewToBottomAnimated:NO];
    
    //Message copying
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
    [self.tableView addGestureRecognizer:longPressRecognizer];
    
    self.keyboardPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    self.keyboardPanRecognizer.delegate = self;
    self.keyboardPanRecognizer.enabled = NO;
    [self.view addGestureRecognizer:self.keyboardPanRecognizer];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self setAppropriateInputHeight];
}

- (void)viewDidLayoutSubviews {
    [self applyTopInset];
}

#pragma mark - Publick methods

- (void) scrollTableViewToBottomAnimated:(BOOL) animated {
    [self.tableView scrollToBottomAnimated:animated];
}

- (void) dismissKeyboard{
    [self.messageToolbar.textView resignFirstResponder];
}

- (void) performAction:(SEL)action withSender:(id)sender userInfo:(NSDictionary *)userInfo {
    [self performAction:action forRowAtIndexPath:userInfo[@"cellIndexPath"] withSender:sender];
}

- (BOOL) shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL) canPerformAction:(SEL)action
        forRowAtIndexPath:(NSIndexPath *)indexPath
               withSender:(id)sender {
    return NO;
}

- (void) performAction:(SEL)action
     forRowAtIndexPath:(NSIndexPath *)indexPath
            withSender:(id)sender {
    
}

#pragma mark - Private methods

- (void)applyTopInset {
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.top = self.topLayoutGuide.length;
    self.tableView.contentInset = contentInset;
    
    UIEdgeInsets scrollIndicatorInset = self.tableView.scrollIndicatorInsets;
    scrollIndicatorInset.top = self.topLayoutGuide.length;
    self.tableView.scrollIndicatorInsets = scrollIndicatorInset;
}

- (void) setAppropriateInputHeight {
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        self.messageToolbar.textView.maximumHeight = kDefaultToolbarPortraitMaximumHeight;
    }
    else{
        self.messageToolbar.textView.maximumHeight = kDefaultToolbarLandscapeMaximumHeight;
    }
}

- (void) longPressRecognized:(UIGestureRecognizer *) recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan && !self.menuPresenter.isPresentingMenu) {
        CGPoint point = [recognizer locationInView:self.tableView];
        NSIndexPath *cellIndex = [self.tableView indexPathForRowAtPoint:point];
        
        if (!cellIndex) {
            return;
        }
        
        if (![self shouldShowMenuForRowAtIndexPath:cellIndex]) {
            return;
        }
        
        __block VKBubbleCell *cell = (VKBubbleCell *)[self.tableView cellForRowAtIndexPath:cellIndex];
        
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
}

- (BOOL) canPerformAction:(SEL)action
               withSender:(id)sender
                 userInfo:(NSDictionary *) userInfo {
    return [self canPerformAction:action
                forRowAtIndexPath:userInfo[@"cellIndexPath"]
                       withSender:sender];
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UIInputToolbarDelegate

-(void) inputButtonPressed:(ZIMInputToolbar *)toolbar {
    if ([toolbar.textView.text length] > 0) {
        toolbar.textView.text = @"";
    }
}

- (void) plusButtonPressed:(ZIMInputToolbar *)toolbar{
    if (self.alternativeInputView) {
        if (toolbar.textView.internalTextView != self.firstResponder) {
            toolbar.textView.inputView = self.alternativeInputView;
            [toolbar.textView becomeFirstResponder];
        }
        else {
            if (toolbar.textView.inputView) {
                toolbar.textView.inputView = nil;
            }
            else {
                toolbar.textView.inputView = self.alternativeInputView;
            }
            [toolbar.textView reloadInputViews];
        }
    }
}

- (void) inputToolbar:(ZIMInputToolbar *)inputToolbar didChangeHeight:(CGFloat)height {
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom = self.view.bounds.size.height - self.messageToolbar.frame.origin.y;
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
}

- (void) inputToolbarDidBeginEditing:(ZIMInputToolbar *)inputToolbar {
    if (!self.menuPresenter.isPresentingMenu) { //Scroll down only when keyboard was hidden
        [self scrollTableViewToBottomAnimated:YES];
    }
}

#pragma  mark - NSNotificationCenter

static inline UIViewAnimationOptions animationOptionsWithCurve(UIViewAnimationCurve curve) {
    return curve << 16;
}

static inline CGRect keyboardRectInView(UIView *view, NSDictionary *keyboardUserInfo) {
    if (keyboardUserInfo) {
        return [view convertRect:[[keyboardUserInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:view.window];
    }
    else {
        return CGRectZero;
    }
}

- (void) keyboardWillShow:(NSNotification *) notification {
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = keyboardRectInView(self.view, info);
    
    if (kbRect.size.height && !self.menuPresenter.isPresentingMenu){
        self.keyboardAnimationCurve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
        self.keyboardAnimationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        [self alighKeyboardControlsToRect:kbRect animated:YES];
    }
}

- (void) keyboardWillHide:(NSNotification *) notification {
    CGRect kbRect = keyboardRectInView(self.view, [notification userInfo]);
    self.keyboardPanRecognizer.enabled = NO;
    if (kbRect.size.height && !self.menuPresenter.isPresentingMenu && !self.keyboard.hidden){
        [self alighKeyboardControlsToRect:kbRect animated:YES];
    }
}

- (void) keyboardDidShow:(NSNotification *) notification {
    if (keyboardRectInView(self.view, [notification userInfo]).size.height) {
        [self catchKeyboard];
        self.menuPresenter.shouldDisplayKeyboard = YES;
        self.keyboardPanRecognizer.enabled = YES;
    }
}

- (void) keyboardDidHide:(NSNotification *) notification {
    if (keyboardRectInView(self.view, [notification userInfo]).size.height) {
        self.menuPresenter.shouldDisplayKeyboard = NO;
        self.keyboard.hidden = NO;
    }
}

- (void) keyboardWillChangeFrame:(CGRect) frame animated:(BOOL) animated {
    
}

#pragma mark - Keyboard control

- (void) catchKeyboard {
    if(self.keyboard)
        return;
    
    //Because we cant get access to the UIKeyboard throught the SDK we will just use UIView.
    //UIKeyboard is a subclass of UIView anyways
    //see discussion http://www.iphonedevsdk.com/forum/iphone-sdk-development/6573-howto-customize-uikeyboard.html
    
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    for(UIView *possibleKeyboard in [tempWindow.subviews copy]) {
        if ([NSStringFromClass([possibleKeyboard class]) isEqualToString:@"UIInputSetContainerView"]){ // iOS 8
            self.keyboard = [possibleKeyboard.subviews firstObject];
            return;
        }
        else if([NSStringFromClass([possibleKeyboard class]) isEqualToString:@"UIPeripheralHostView"]) { // pre iOS 8
            self.keyboard = possibleKeyboard;
            return;
        }
    }
}

- (void) alighKeyboardControlsToRect:(CGRect) rect animated:(BOOL) animated {
    
    __weak __typeof(&*self) weakSelf = self;
    void (^alignControlsToRect)()  = ^() {
        if (!weakSelf) {
            return;
        }
        
        CGRect toolBarFrame = weakSelf.messageToolbar.frame;
        toolBarFrame.origin.y = rect.origin.y - toolBarFrame.size.height;
        weakSelf.messageToolbar.frame = toolBarFrame;
        
        UIEdgeInsets newContentInsets = weakSelf.tableView.contentInset;
        newContentInsets.bottom = weakSelf.view.bounds.size.height - toolBarFrame.origin.y;
        
        weakSelf.tableView.scrollIndicatorInsets = newContentInsets;
        weakSelf.tableView.contentInset = newContentInsets;
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

-(void) panGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:[self view]];
    CGPoint velocity = [gestureRecognizer velocityInView:self.view];
    CGFloat spaceAboveKeyboard = self.view.bounds.size.height - (self.keyboard.frame.size.height + self.messageToolbar.frame.size.height);
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.originalKeyboardY = self.keyboard.frame.origin.y;
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
                [self.keyboard setFrame: newFrame];
                [self alighKeyboardControlsToRect:[self.view convertRect:newFrame fromView:self.keyboard.superview]
                                         animated:NO];
            }
            break;
            
        default:
            break;
    }
}

- (void) animateKeyboardOffscreen {
    __block CGRect newFrame = self.keyboard.frame;
    newFrame.origin.y = self.keyboard.superview.bounds.size.height;
    self.keyboardPanRecognizer.enabled = NO;
    
    [UIView animateWithDuration:self.keyboardAnimationDuration
                          delay:0
                        options:animationOptionsWithCurve(self.keyboardAnimationCurve)
                     animations:^{
                         [self.keyboard setFrame:newFrame];
                         [self alighKeyboardControlsToRect:[self.view convertRect:newFrame fromView:self.keyboard.superview]
                                                  animated:NO];
                     }
                     completion:^(BOOL finished){
                         // To remove the animation for the keyboard dropping showing
                         // we have to hide the keyboard, and on will show we set it back.
                         self.keyboard.hidden = YES;
                         [self.messageToolbar.textView resignFirstResponder];
                     }];
}

- (void) animateKeyboardReturnToOriginalPosition {
    CGRect newFrame = self.keyboard.frame;
    newFrame.origin.y = self.originalKeyboardY;
    
    if (!CGRectEqualToRect(newFrame, self.keyboard.frame)) {
        [UIView beginAnimations:nil context:NULL];
        [self.keyboard setFrame: newFrame];
        [self alighKeyboardControlsToRect:[self.view convertRect:newFrame fromView:self.keyboard.superview]
                                 animated:NO];
        [UIView commitAnimations];
    }
}

- (void) restoreKeyboard {
    self.keyboard.userInteractionEnabled = YES;
    self.keyboard.hidden = NO;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return (gestureRecognizer == self.keyboardPanRecognizer || otherGestureRecognizer == self.keyboardPanRecognizer);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.keyboardPanRecognizer) {
        // Don't allow panning if inside the active input (unless SELF is a UITextView and the receiving view)
        return (![touch.view isFirstResponder] || ([self isKindOfClass:[UITextView class]] && [self isEqual:touch.view]));
    } else {
        return YES;
    }
}

@end















