//
//  VKDefaultBubbleCell+VKImageBubbleCell.h
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 15/01/14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKDefaultBubbleCell.h"
#import "VKImageBubbleView.h"

extern NSString *VKInboundImageBubbleCellReuseIdentifier;
extern NSString *VKOutboundImageBubbleCellReuseIdentifier;

@interface VKDefaultBubbleCell (VKImageBubbleCell)

+ (VKBubbleCell *) newInboundImageBubbleCell;
+ (VKBubbleCell *) newOutboundImageBubbleCell;

+ (CGFloat) heightForInboundBubbleCellWithImageSize:(CGSize) image widht:(CGFloat) width;
+ (CGFloat) heightForOutboundBubbleCellWithImageSize:(CGSize) image widht:(CGFloat) width;
+ (CGFloat) heightForInboundBubbleCellWithImage:(UIImage *) image widht:(CGFloat) width;
+ (CGFloat) heightForOutboundBubbleCellWithImage:(UIImage *) image widht:(CGFloat) width;

+ (VKDefaultBubbleCell *) getInboundImageMessageCell:(UITableView *) tableView;
+ (VKDefaultBubbleCell *) getOutboundImageMessageCell:(UITableView *) tableView;

@end
