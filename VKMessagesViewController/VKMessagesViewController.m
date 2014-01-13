//
//  VKMessagesViewController.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKMessagesViewController.h"
#import "DAKeyboardControl.h"
#import "UIViewController+firstResponder.h"
#import "VKMenuControllerPresenter.h"
#import "VKiOSVersionCheck.h"
#import "VKTextBubbleView.h"

#define kDefaultToolbarHeight 40
#define kDefaultToolbarPortraitMaximumHeight 195
#define kDefaultToolbarLandscapeMaximumHeight 101

@interface VKMessagesViewController ()
@property (strong, nonatomic) VKMenuControllerPresenter *menuPresenter;
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

- (VKTextBubbleViewProperties *) inboundBubbleViewProperties{
    if (!_inboundBubbleViewProperties) {
        if (SYSTEM_VERSION_LESS_THAN(@"7")) {
            _inboundBubbleViewProperties = [VKTextBubbleViewProperties defaultProperties];
            _inboundBubbleViewProperties.edgeInsets = UIEdgeInsetsMake(4, 8, 4, 4);
        }
        else {
            _inboundBubbleViewProperties = [VKTextBubbleViewProperties defaultProperties];
            _inboundBubbleViewProperties.edgeInsets = UIEdgeInsetsMake(4, 16, 4, 12);
        }
    }
    return _inboundBubbleViewProperties;
}

- (VKTextBubbleViewProperties *) outboundBubbleViewProperties{
    if (!_outboundBubbleViewProperties) {
        if (SYSTEM_VERSION_LESS_THAN(@"7")) {
            _outboundBubbleViewProperties = [VKTextBubbleViewProperties defaultProperties];
            _outboundBubbleViewProperties.edgeInsets = UIEdgeInsetsMake(4, 4, 4, 8);
        }
        else {
            _outboundBubbleViewProperties = [VKTextBubbleViewProperties defaultProperties];
            _outboundBubbleViewProperties.edgeInsets = UIEdgeInsetsMake(4, 12, 4, 16);
        }
    }
    return _outboundBubbleViewProperties;
}

- (UIImage *) inboundCellBackgroudImage{
    if (!_inboundCellBackgroudImage) {
        UIImage *image = nil;
        if (SYSTEM_VERSION_LESS_THAN(@"7")) {
            image = [UIImage imageNamed:@"vk_message_bubble_incoming"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height * (2.0/3.0)),
                                                                        floorf(image.size.width * (2.0/3.0)),
                                                                        floorf(image.size.height * (1.0/3.0)),
                                                                        floorf(image.size.width * (1.0/3.0)))];
        }
        else{
            image = [UIImage imageNamed:@"vk_message_bubble_incoming_ios7"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height / 2),
                                                                        floorf(image.size.width * 0.56),
                                                                        floorf(image.size.height / 2),
                                                                        floorf(image.size.width * 0.44))];
        }
        _inboundCellBackgroudImage = image;
    }
    return _inboundCellBackgroudImage;
}

- (UIImage *) outboundCellBackgroudImage{
    if (!_outboundCellBackgroudImage) {
        UIImage *image = nil;
        if (SYSTEM_VERSION_LESS_THAN(@"7")) {
            image = [UIImage imageNamed:@"vk_message_bubble_outgouing"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height * (2.0/3.0)),
                                                                        floorf(image.size.width * (1.0/3.0)),
                                                                        floorf(image.size.height * (1.0/3.0)),
                                                                        floorf(image.size.width * (2.0/3.0)))];
        }
        else {
            image = [UIImage imageNamed:@"vk_message_bubble_outgouing_ios7"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height / 2),
                                                                        floorf(image.size.width * 0.44),
                                                                        floorf(image.size.height / 2),
                                                                        floorf(image.size.width * 0.56))];
        }
        _outboundCellBackgroudImage = image;
    }
    return _outboundCellBackgroudImage;
}

- (UIImage *) inboundSelectedCellBackgroudImage{
    if (!_inboundSelectedCellBackgroudImage) {
        UIImage *image = [UIImage imageNamed:@"vk_message_bubble_incoming_selected"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height * (2.0/3.0)),
                                                                    floorf(image.size.width * (2.0/3.0)),
                                                                    floorf(image.size.height * (1.0/3.0)),
                                                                    floorf(image.size.width * (1.0/3.0)))];
        _inboundSelectedCellBackgroudImage = image;
    }
    return _inboundSelectedCellBackgroudImage;
}

- (UIImage *) outboundSelectedCellBackgroudImage{
    if (!_outboundSelectedCellBackgroudImage) {
        UIImage *image = [UIImage imageNamed:@"vk_message_bubble_outgouing_selected"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height * (2.0/3.0)),
                                                                    floorf(image.size.width * (1.0/3.0)),
                                                                    floorf(image.size.height * (1.0/3.0)),
                                                                    floorf(image.size.width * (2.0/3.0)))];
        _outboundSelectedCellBackgroudImage = image;
    }
    return _outboundSelectedCellBackgroudImage;
}

- (NSDateFormatter *) messageDateFormatter{
    if (!_messageDateFormatter) {
        _messageDateFormatter = [[NSDateFormatter alloc] init];
        [_messageDateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [_messageDateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [_messageDateFormatter setDoesRelativeDateFormatting:YES];
    }
    return _messageDateFormatter;
}

- (VKMenuControllerPresenter *) menuPresenter{
    if (!_menuPresenter) {
        _menuPresenter = [[VKMenuControllerPresenter alloc] initWithParentView:self.view];
    }
    return _menuPresenter;
}

#pragma mark - ViewController lifecycle

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupKeyboardControl];
    [self.tableView reloadData];
    [self scrollTableViewToBottomAnimated:NO];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view removeKeyboardControl];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    static BOOL isFirstRun = NO;
    if (!isFirstRun) {
        [self.view hideKeyboard];
        isFirstRun = YES;
        
        CGRect toolbarFrame = self.messageToolbar.frame;
        toolbarFrame.origin.y = self.view.frame.size.height - self.messageToolbar.frame.size.height;
        self.messageToolbar.frame = toolbarFrame;
    }
}

- (void)viewDidLoad
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
    
    if (SYSTEM_VERSION_LESS_THAN(@"7")) {
        //Setting style
        self.tableView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        
        //Message copying
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
        [self.tableView addGestureRecognizer:longPressRecognizer];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidHide:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
    }
}

- (void) dealloc{
    [self.view removeKeyboardControl];
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

#pragma mark - Cell factory methods

- (VKBubbleCell *) getInboundTextMessageCell:(UITableView *) tableView{
    NSString static *inboundReuseIdentifier =  @"InboundMessageCell";
    VKBubbleCell *messageCell = [tableView dequeueReusableCellWithIdentifier:inboundReuseIdentifier];
    
    if (messageCell == nil) {
        VKTextBubbleView *textBubbleView = [[VKTextBubbleView alloc] initWithProperties:self.inboundBubbleViewProperties];
        
        messageCell = [[VKBubbleCell alloc] initWithBubbleView:textBubbleView
                                                reuseIdentifier:inboundReuseIdentifier];
        [messageCell setBackgroundImage:self.inboundCellBackgroudImage forStyle:VKMessageCellStyleNormal];
        [messageCell setBackgroundImage:self.inboundSelectedCellBackgroudImage forStyle:VKMessageCellStyleSelected];
        messageCell.bubbleAlign = VKBubbleAlignLeft;
        messageCell.dateFormatter = self.messageDateFormatter;
        messageCell.backgroundColor = [UIColor clearColor];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
            UIColor *headerColor = [UIColor colorWithRed:0.5
                                                   green:0.5
                                                    blue:0.5
                                                   alpha:0.5];
            textBubbleView.textBody.textColor = [UIColor blackColor];
            textBubbleView.messageRightHeader.shadowColor = nil;
            textBubbleView.messageLeftHeader.shadowColor = nil;
            textBubbleView.messageRightHeader.textColor = headerColor;
            textBubbleView.messageLeftHeader.textColor = headerColor;
        }
    }
    return messageCell;
}

- (VKBubbleCell *) getOutboundTextMessageCell:(UITableView *) tableView{
    NSString static *outboundReuseIdentifier =  @"OutboundMessageCell";
    VKBubbleCell *messageCell = [tableView dequeueReusableCellWithIdentifier:outboundReuseIdentifier];
    
    if (messageCell == nil) {
        VKTextBubbleView *textBubbleView = [[VKTextBubbleView alloc] initWithProperties:self.outboundBubbleViewProperties];
        messageCell = [[VKBubbleCell alloc] initWithBubbleView:textBubbleView
                                                reuseIdentifier:outboundReuseIdentifier];
        [messageCell setBackgroundImage:self.outboundCellBackgroudImage forStyle:VKMessageCellStyleNormal];
        [messageCell setBackgroundImage:self.outboundSelectedCellBackgroudImage forStyle:VKMessageCellStyleSelected];
        messageCell.bubbleAlign = VKBubbleAlignRight;
        messageCell.dateFormatter = self.messageDateFormatter;
        messageCell.backgroundColor = [UIColor clearColor];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
            UIColor *headerColor = [UIColor colorWithRed:1
                                                   green:1
                                                    blue:1
                                                   alpha:0.5];
            textBubbleView.textBody.textColor = [UIColor whiteColor];
            textBubbleView.messageRightHeader.shadowColor = nil;
            textBubbleView.messageLeftHeader.shadowColor = nil;
            textBubbleView.messageRightHeader.textColor = headerColor;
            textBubbleView.messageLeftHeader.textColor = headerColor;
        }
    }
    return messageCell;
}

#pragma mark - Publick methods

- (void) scrollTableViewToBottomAnimated:(BOOL) animated{
    [self.tableView scrollToBottomAnimated:animated];
}

- (void) dismissKeyboard{
    [self.messageToolbar.textView resignFirstResponder];
}

- (void) inputButtonPressed{
    
}

- (void) plusButtonPressed{
    
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

- (void) setupKeyboardControl {
    // Prepare keyboard control
    self.view.keyboardTriggerOffset = self.messageToolbar.frame.size.height;
    __weak __typeof(&*self) weakSelf = self;
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {
        weakSelf.tableView.scrollEnabled = NO;
        weakSelf.tableView.scrollEnabled = YES;
        CGRect toolBarFrame = weakSelf.messageToolbar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        weakSelf.messageToolbar.frame = toolBarFrame;
        
        CGRect tableViewFrame = weakSelf.tableView.frame;
        tableViewFrame.size.height = toolBarFrame.origin.y;
        
        UIEdgeInsets insets = weakSelf.tableView.contentInset;
        insets.bottom = weakSelf.view.bounds.size.height - toolBarFrame.origin.y;
        weakSelf.tableView.contentInset = insets;
        weakSelf.tableView.scrollIndicatorInsets = insets;
    }];
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
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [recognizer locationInView:self.tableView];
        NSIndexPath *cellIndex = [self.tableView indexPathForRowAtPoint:point];
        VKBubbleCell *cell = (VKBubbleCell *)[self.tableView cellForRowAtIndexPath:cellIndex];
        [cell setSelected:YES];
        
        [self.menuPresenter showDefaultMenuForView:cell.bubbleView
                                     returnFocusTo:self.firstResponder
                                        completeon:^{
                                            [cell setSelected:NO];
                                        }];
    }
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UIInputToolbarDelegate

-(void)inputButtonPressed:(UIInputToolbar *)toolbar{
    [self inputButtonPressed];
    if ([toolbar.textView.text length] > 0) {
        [self scrollTableViewToBottomAnimated:YES];
        toolbar.textView.text = @"";
    }
}

- (void) plusButtonPressed:(UIInputToolbar *)toolbar{
    [self plusButtonPressed];
    
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
    self.view.keyboardTriggerOffset = self.messageToolbar.frame.size.height;
}

#pragma  mark - NSNotificationCenter
- (void) keyboardWillShow:(NSNotification *) notification{
    [self scrollTableViewToBottomAnimated:YES];
}

- (void) keyboardDidShow:(NSNotification *) notification{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [self.view convertRect:[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:self.view.window];
    if (!kbRect.size.height){
        return;
    }
    self.menuPresenter.shouldDisplayKeyboard = YES;
}

- (void) keyboardDidHide:(NSNotification *) notification{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [self.view convertRect:[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:self.view.window];
    if (!kbRect.size.height){
        return;
    }
    self.menuPresenter.shouldDisplayKeyboard = NO;
}

@end















