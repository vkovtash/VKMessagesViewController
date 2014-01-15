//
//  VKBaseBubbleCell+VKTextBubbleCell.h
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 13/01/14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKDefaultBubbleCell.h"
#import "VKTextBubbleView.h"

extern NSString *VKInboundTextBubbleCellReuseIdentifier;
extern NSString *VKOutboundTextBubbleCellReuseIdentifier;

@interface VKDefaultBubbleCell (VKTextBubbleCell)

+ (VKBubbleCell *) newInboundTextBubbleCell;
+ (VKBubbleCell *) newOutboundTextBubbleCell;

+ (CGFloat) heightForInboundTextBubbleCell:(NSString *) text Widht:(CGFloat) width;
+ (CGFloat) heightForOutboundTextBubbleCell:(NSString *) text Widht:(CGFloat) width;

@end
