//
//  VKMessagesViewController.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKMessagesViewController.h"
#import "UIViewController+firstResponder.h"
#import "VKMenuControllerPresenter.h"
#import "VKiOSVersionCheck.h"

static CGFloat const kDefaultToolbarHeight = 40;
static CGFloat const kDefaultToolbarPortraitMaximumHeight = 195;
static CGFloat const kDefaultToolbarLandscapeMaximumHeight = 101;

@interface VKMessagesViewController () <UIGestureRecognizerDelegate, VKMenuControllerPresenterDelegate>
@property (strong, nonatomic) VKMenuControllerPresenter *menuPresenter;
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
    if (_alternativeInputView != alternativeInputView) {
        _alternativeInputView = alternativeInputView;
        self.messageToolbar.isPlusButtonVisible = (BOOL)_alternativeInputView;
    }
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

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    static BOOL isFirstRun = NO;
    if (!isFirstRun) {
        isFirstRun = YES;
        
        CGRect toolbarFrame = self.messageToolbar.frame;
        toolbarFrame.origin.y = self.view.frame.size.height - self.messageToolbar.frame.size.height;
        self.messageToolbar.frame = toolbarFrame;
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    /* Create toolbar */
    self.messageToolbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0,
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
    [self applyTopInset];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.messageToolbar];
    [self inputToolbar:self.messageToolbar DidChangeHeight:self.messageToolbar.frame.size.height];
    
    // Scroll table to bottom cell
    [self scrollTableViewToBottomAnimated:NO];
    
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
    
    if (SYSTEM_VERSION_LESS_THAN(@"7")) {
        //Setting style
        self.tableView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    }
    
    //Message copying
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
    [self.tableView addGestureRecognizer:longPressRecognizer];
    
    self.keyboardPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    self.keyboardPanRecognizer.delegate = self;
    self.keyboardPanRecognizer.enabled = NO;
    [self.view addGestureRecognizer:self.keyboardPanRecognizer];
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self applyTopInset];
    [self setAppropriateInputHeight];
}

#pragma mark - Publick methods

- (void) scrollTableViewToBottomAnimated:(BOOL) animated{
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

- (void) applyTopInset { //apply table view offsets for iOS7
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)] && self.edgesForExtendedLayout | UIRectEdgeTop){
        CGFloat topInset = 0;
        UIEdgeInsets insets;
        
        if (![self prefersStatusBarHidden]) {
            topInset += 20; //statusbar height
        }
        
        if (self.navigationController){
            topInset += self.navigationController.navigationBar.frame.size.height;
        }
        
        insets = self.tableView.contentInset;
        insets.top = topInset;
        self.tableView.contentInset = insets;
        
        insets = self.tableView.scrollIndicatorInsets;
        insets.top = topInset;
        self.tableView.scrollIndicatorInsets = insets;
    }
}

- (void) setAppropriateInputHeight{
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
        
        if (![self shouldShowMenuForRowAtIndexPath:cellIndex]) {
            return;
        }
        
        VKBubbleCell *cell = (VKBubbleCell *)[self.tableView cellForRowAtIndexPath:cellIndex];
        
        [cell setSelected:YES];
        [self.menuPresenter showDefaultMenuWithResponder:self
                                                userInfo:@{@"cellIndexPath":cellIndex}
                                                  inView:cell.bubbleView
                                           returnFocusTo:self.firstResponder
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

-(void)inputButtonPressed:(UIInputToolbar *)toolbar {
    if ([toolbar.textView.text length] > 0) {
        toolbar.textView.text = @"";
    }
}

- (void) plusButtonPressed:(UIInputToolbar *)toolbar{
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

- (void) inputToolbar:(UIInputToolbar *)inputToolbar DidChangeHeight:(CGFloat)height{
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom = self.view.bounds.size.height - self.messageToolbar.frame.origin.y;
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
}

- (void) inputToolbarDidBeginEditing:(UIInputToolbar *)inputToolbar {
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
    // To remove the animation for the keyboard dropping showing
    // we have to hide the keyboard, and on will show we set it back.
    self.keyboard.hidden = NO;
    
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
    if (kbRect.size.height && !self.menuPresenter.isPresentingMenu){
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
        self.keyboardPanRecognizer.enabled = NO;
    }
}

#pragma mark - Keyboard control

- (void) catchKeyboard {
    if(self.keyboard)
        return;
    
    //Because we cant get access to the UIKeyboard throught the SDK we will just use UIView.
    //UIKeyboard is a subclass of UIView anyways
    //see discussion http://www.iphonedevsdk.com/forum/iphone-sdk-development/6573-howto-customize-uikeyboard.html
    
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    UIView *possibleKeyboard = nil;
    for(int i = 0; i < [tempWindow.subviews count]; i++) {
        possibleKeyboard = [tempWindow.subviews objectAtIndex:i];
        if([NSStringFromClass([possibleKeyboard class]) isEqualToString:@"UIPeripheralHostView"]) {
            self.keyboard = possibleKeyboard;
            return;
        }
    }
}

- (void) alighKeyboardControlsToRect:(CGRect) rect animated:(BOOL) animated {
    
    __weak __typeof(&*self) weakSelf = self;
    void (^alignControlsToRect)(CGRect keyboardFrame)  = ^(CGRect keyboardFrame) {
        if (!weakSelf) {
            return;
        }
        
        weakSelf.tableView.scrollEnabled = NO;
        weakSelf.tableView.scrollEnabled = YES;
        CGRect toolBarFrame = weakSelf.messageToolbar.frame;
        toolBarFrame.origin.y = keyboardFrame.origin.y - toolBarFrame.size.height;
        weakSelf.messageToolbar.frame = toolBarFrame;
        
        CGRect tableViewFrame = weakSelf.tableView.frame;
        tableViewFrame.size.height = toolBarFrame.origin.y;
        
        UIEdgeInsets insets = weakSelf.tableView.contentInset;
        insets.bottom = weakSelf.view.bounds.size.height - toolBarFrame.origin.y;
        weakSelf.tableView.contentInset = insets;
        weakSelf.tableView.scrollIndicatorInsets = insets;
    };
    
    if (animated) {
        if (self.keyboardAnimationDuration > 0) {
            [UIView animateWithDuration:self.keyboardAnimationDuration
                                  delay:0
                                options:animationOptionsWithCurve(self.keyboardAnimationCurve)
                             animations:^{
                                 alignControlsToRect(rect);
                             }
                             completion:nil];
        }
    }
    else {
        alignControlsToRect(rect);
    }
}

-(void) panGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:[self view]];
    CGPoint velocity = [gestureRecognizer velocityInView:self.view];
    
    CGFloat spaceAboveKeyboard = self.view.bounds.size.height - (self.keyboard.frame.size.height + self.messageToolbar.frame.size.height);
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        self.originalKeyboardY = self.keyboard.frame.origin.y;
        self.keyboard.userInteractionEnabled = NO;
    }
    
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        if (velocity.y > 0 && location.y > spaceAboveKeyboard) {
            [self animateKeyboardOffscreen];
        }
        else {
            [self animateKeyboardReturnToOriginalPosition];
        }
        self.keyboard.userInteractionEnabled = YES;
        return;
    }
    
    if (location.y < spaceAboveKeyboard) {
        return;
    }
    
    CGRect newFrame = self.keyboard.frame;
    CGFloat newY = self.originalKeyboardY + (location.y - spaceAboveKeyboard);
    newY = MAX(newY, self.originalKeyboardY);
    newFrame.origin.y = newY;
    [self.keyboard setFrame: newFrame];
    [self alighKeyboardControlsToRect:newFrame animated:NO];
}

- (void) animateKeyboardOffscreen {
    __block CGRect newFrame = self.keyboard.frame;
    newFrame.origin.y = self.keyboard.window.frame.size.height;
    self.keyboardPanRecognizer.enabled = NO;
    
    [UIView animateWithDuration:self.keyboardAnimationDuration
                          delay:0
                        options:animationOptionsWithCurve(self.keyboardAnimationCurve)
                     animations:^{
                         [self.keyboard setFrame: newFrame];
                         [self alighKeyboardControlsToRect:newFrame animated:NO];
                     }
                     completion:^(BOOL finished){
                         self.keyboard.hidden = YES;
                         [self.messageToolbar.textView resignFirstResponder];
                     }];
}

- (void) animateKeyboardReturnToOriginalPosition {
    CGRect newFrame = self.keyboard.frame;
    newFrame.origin.y = self.originalKeyboardY;
    
    [UIView beginAnimations:nil context:NULL];
    [self.keyboard setFrame: newFrame];
    [self alighKeyboardControlsToRect:newFrame animated:NO];
    [UIView commitAnimations];
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















