//
//  VKInboundTextBubbleCell.h
//  VKMessagesViewController
//
//  Created by kovtash on 04.02.14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKInboundBaseBubbleCell.h"
#import "VKTextBubbleView.h"

@class VKTextBubbleViewProperties;
extern NSString *VKInboundTextBubbleCellReuseIdentifier;

@interface VKInboundTextBubbleCell : VKInboundBaseBubbleCell
@property (nonatomic, readonly) VKTextBubbleView *bubbleView;
@property (readwrite, nonatomic) NSString *messageText;

+ (VKTextBubbleView *) newBubbleView;
+ (VKTextBubbleViewProperties *) newBubbleViewProperties;
+ (CGFloat) heightForText:(NSString *) text widht:(CGFloat) width;
@end
