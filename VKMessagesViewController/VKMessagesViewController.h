//
//  VKMessagesViewController.h
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIInputToolbar.h"
#import "VKEmojiPicker+style.h"
#import "VKBubbleCell.h"
#import "VKTableView.h"
#import "VKTextBubbleViewProperties.h"

@interface VKMessagesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,
                                                        UIInputToolbarDelegate, VKEmojiPickerDelegate>

@property (strong, nonatomic) VKTableView *tableView;
@property (strong, nonatomic) UIInputToolbar *messageToolbar;
@property (strong, nonatomic) UIView *alternativeInputView; //view shown on plus button tap
@property (readwrite, nonatomic) NSString *messagePlaceholder;

- (void) scrollTableViewToBottomAnimated:(BOOL) animated;
- (void) dismissKeyboard;
- (void) inputButtonPressed;
- (void) plusButtonPressed;

#pragma mark - factory methods
- (VKBubbleCell *) getInboundTextMessageCell:(UITableView *) tableView;
- (VKBubbleCell *) getOutboundTextMessageCell:(UITableView *) tableView;
@end
