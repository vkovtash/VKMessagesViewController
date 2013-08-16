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
#import "VKMessageCell.h"
#import "VKTableView.h"

@interface VKMessagesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,
                                                        UIInputToolbarDelegate, VKEmojiPickerDelegate>

@property (strong, nonatomic) VKTableView *tableView;
@property (strong, nonatomic) UIInputToolbar *messageToolbar;
@property (readwrite, nonatomic) NSString *messagePlaceholder;
@property (strong, nonatomic) VKBubbleViewProperties *inboundBubbleViewProperties;
@property (strong, nonatomic) VKBubbleViewProperties *outboundBubbleViewProperties;
@property (strong, nonatomic) UIImage *inboundCellBackgroudImage;
@property (strong, nonatomic) UIImage *outboundCellBackgroudImage;
@property (strong, nonatomic) UIImage *inboundSelectedCellBackgroudImage;
@property (strong, nonatomic) UIImage *outboundSelectedCellBackgroudImage;
@property (strong, nonatomic) NSDateFormatter *messageDateFormatter;

- (void) scrollTableViewToBottomAnimated:(BOOL) animated;
- (void) dismissKeyboard;
- (void) inputButtonPressed;
- (void) plusButtonPressed;

#pragma mark - factory methods
- (VKMessageCell *) getInboundMessageCell:(UITableView *) tableView;
- (VKMessageCell *) getOutboundMessageCell:(UITableView *) tableView;
@end
