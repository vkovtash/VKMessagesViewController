//
//  VKMessagesViewController.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKMessagesViewController.h"
#import "DAKeyboardControl.h"
#import "NSString+deletingLastSymbol.h"
#import "UIViewController+firstResponder.h"
#import "VKMenuControllerPresenter.h"

#define kDefaultToolbarHeight 40
#define kDefaultToolbarPortraitMaximumHeight 195
#define kDefaultToolbarLandscapeMaximumHeight 101

static VKEmojiPicker *emojiPicker;

@interface VKMessagesViewController ()
@property (strong, nonatomic) VKEmojiPicker *emojiPicker;
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

- (VKBubbleViewProperties *) inboundBubbleViewProperties{
    if (!_inboundBubbleViewProperties) {
        _inboundBubbleViewProperties = [VKBubbleViewProperties defaultProperties];
        _inboundBubbleViewProperties.edgeInsets = UIEdgeInsetsMake(4, 8, 4, 4);
    }
    return _inboundBubbleViewProperties;
}

- (VKBubbleViewProperties *) outboundBubbleViewProperties{
    if (!_outboundBubbleViewProperties) {
        _outboundBubbleViewProperties = [VKBubbleViewProperties defaultProperties];
        _outboundBubbleViewProperties.edgeInsets = UIEdgeInsetsMake(4, 4, 4, 8);
    }
    return _outboundBubbleViewProperties;
}

- (UIImage *) inboundCellBackgroudImage{
    if (!_inboundCellBackgroudImage) {
        UIImage *image = [UIImage imageNamed:@"vk_message_bubble_incoming"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height*(2.0/3.0)),
                                                                    floorf(image.size.width*(2.0/3.0)),
                                                                    floorf(image.size.height*(1.0/3.0)),
                                                                    floorf(image.size.width*(1.0/3.0)))];
        _inboundCellBackgroudImage = image;
    }
    return _inboundCellBackgroudImage;
}

- (UIImage *) outboundCellBackgroudImage{
    if (!_outboundCellBackgroudImage) {
        UIImage *image = [UIImage imageNamed:@"vk_message_bubble_outgouing"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height*(2.0/3.0)),
                                                                    floorf(image.size.width*(1.0/3.0)),
                                                                    floorf(image.size.height*(1.0/3.0)),
                                                                    floorf(image.size.width*(2.0/3.0)))];
        _outboundCellBackgroudImage = image;
    }
    return _outboundCellBackgroudImage;
}

- (UIImage *) inboundSelectedCellBackgroudImage{
    if (!_inboundSelectedCellBackgroudImage) {
        UIImage *image = [UIImage imageNamed:@"vk_message_bubble_incoming_selected"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height*(2.0/3.0)),
                                                                    floorf(image.size.width*(2.0/3.0)),
                                                                    floorf(image.size.height*(1.0/3.0)),
                                                                    floorf(image.size.width*(1.0/3.0)))];
        _inboundSelectedCellBackgroudImage = image;
    }
    return _inboundSelectedCellBackgroudImage;
}

- (UIImage *) outboundSelectedCellBackgroudImage{
    if (!_outboundSelectedCellBackgroudImage) {
        UIImage *image = [UIImage imageNamed:@"vk_message_bubble_outgouing_selected"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height*(2.0/3.0)),
                                                                    floorf(image.size.width*(1.0/3.0)),
                                                                    floorf(image.size.height*(1.0/3.0)),
                                                                    floorf(image.size.width*(2.0/3.0)))];
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

#pragma mark - Private properties

- (void) setEmojiPicker:(VKEmojiPicker *)emojiPicker{
    if (_emojiPicker != emojiPicker) {
        _emojiPicker.delegate = nil;
        _emojiPicker = emojiPicker;
        _emojiPicker.delegate = self;
        self.view.keyboardCoverView = _emojiPicker;
    }
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
    [self.tableView reloadData];
    [self scrollTableViewToBottomAnimated:NO];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.view hideKeyboard];
    CGRect toolbarFrame = self.messageToolbar.frame;
    toolbarFrame.origin.y = self.view.frame.size.height-self.messageToolbar.frame.size.height;
    self.messageToolbar.frame = toolbarFrame;
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.messageToolbar.frame.origin.y);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* Create toolbar */
    self.messageToolbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0,
                                                                           self.view.frame.size.height-kDefaultToolbarHeight,
                                                                           self.view.frame.size.width,
                                                                           kDefaultToolbarHeight)];
    self.messageToolbar.inputDelegate = self;
    self.messageToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    self.messageToolbar.textView.animateHeightChange = NO; //Prevent table scroll animation on appear
    self.messageToolbar.textView.animateHeightChange = YES; //Restore animated size change
    [self setAppropriateInputHeight];
    
    self.messagePlaceholder = @"Message";
    
    /* Set Table View properties */
    self.tableView = [[VKTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.messageToolbar.frame.origin.y)];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
    [self.tableView addGestureRecognizer:longPressRecognizer];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.messageToolbar];
    
    /* Prepare keyboard control */
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
        weakSelf.tableView.frame = tableViewFrame;
    }];
    
    /* Prepare emoji picker */
    if (!emojiPicker) {
        dispatch_async(dispatch_get_main_queue(), ^{
            emojiPicker = [VKEmojiPicker emojiPicker];
            if ([weakSelf respondsToSelector:@selector(setEmojiPicker:)]) {
                weakSelf.emojiPicker = emojiPicker;
            }
        });
    }
    else{
        self.emojiPicker = emojiPicker;
    }
    
    /* Scroll table to bottom cell */
    [self scrollTableViewToBottomAnimated:NO];
    
    /*Register for keyboard notifications*/
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
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
    [self setAppropriateInputHeight];
}

#pragma mark - Cell factory methods

- (VKMessageCell *) getInboundMessageCell:(UITableView *) tableView{
    NSString static *inboundReuseIdentifier =  @"InboundMessageCell";
    VKMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:inboundReuseIdentifier];
    
    if (messageCell == nil) {
        messageCell = [[VKMessageCell alloc] initWithBubbleView:[[VKBubbleView alloc] initWithProperties:self.inboundBubbleViewProperties]
                                                reuseIdentifier:inboundReuseIdentifier];
        [messageCell setBackgroundImage:self.inboundCellBackgroudImage forStyle:VKMessageCellStyleNormal];
        [messageCell setBackgroundImage:self.inboundSelectedCellBackgroudImage forStyle:VKMessageCellStyleSelected];
        messageCell.bubbleAlign = VKBubbleAlignLeft;
        messageCell.dateFormatter = self.messageDateFormatter;
        messageCell.backgroundColor = [UIColor clearColor];
    }
    return messageCell;
}

- (VKMessageCell *) getOutboundMessageCell:(UITableView *) tableView{
    NSString static *outboundReuseIdentifier =  @"OutboundMessageCell";
    VKMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:outboundReuseIdentifier];
    
    if (messageCell == nil) {
        messageCell = [[VKMessageCell alloc] initWithBubbleView:[[VKBubbleView alloc] initWithProperties:self.outboundBubbleViewProperties]
                                                reuseIdentifier:outboundReuseIdentifier];
        [messageCell setBackgroundImage:self.outboundCellBackgroudImage forStyle:VKMessageCellStyleNormal];
        [messageCell setBackgroundImage:self.outboundSelectedCellBackgroudImage forStyle:VKMessageCellStyleSelected];
        messageCell.bubbleAlign = VKBubbleAlignRight;
        messageCell.dateFormatter = self.messageDateFormatter;
        messageCell.backgroundColor = [UIColor clearColor];
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
        VKMessageCell *cell = (VKMessageCell *)[self.tableView cellForRowAtIndexPath:cellIndex];
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
    if (self.emojiPicker) {
        [toolbar.textView becomeFirstResponder];
        self.view.isKeyboardCoverViewVisible = !self.view.isKeyboardCoverViewVisible;
    }
}

- (BOOL) inputToolbarShouldBeginEditing:(UIInputToolbar *)inputToolbar{
    [self scrollTableViewToBottomAnimated:YES];
    return YES;
}

- (void) inputToolbar:(UIInputToolbar *)inputToolbar DidChangeHeight:(CGFloat)height{
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.messageToolbar.frame.origin.y);
    self.view.keyboardTriggerOffset = self.messageToolbar.frame.size.height;
}

#pragma mark - UDEmojiPickerDelegate

- (void) emojiPicker:(VKEmojiPicker *)picker SymbolPicked:(NSString *)emojiSimbol{
    self.messageToolbar.textView.text = [self.messageToolbar.textView.text stringByAppendingString:emojiSimbol];
}

- (void) emojiPickerDelButtonPressed:(VKEmojiPicker *)picker{
    self.messageToolbar.textView.text = [self.messageToolbar.textView.text stringByDeletingLastSymbol];
}

#pragma  mark - NSNotificationCenter

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















