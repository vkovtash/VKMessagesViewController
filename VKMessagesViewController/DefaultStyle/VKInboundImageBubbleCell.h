//
//  VKInboundImageBubbleCell.h
//  VKMessagesViewController
//
//  Created by kovtash on 04.02.14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKInboundBaseBubbleCell.h"
#import "VKImageBubbleView.h"

extern NSString *VKInboundImageBubbleCellReuseIdentifier;

@interface VKInboundImageBubbleCell : VKInboundBaseBubbleCell
@property (nonatomic, readonly) VKImageBubbleView *bubbleView;

+ (VKImageBubbleView *) newBubbleView;
+ (VKImageBubbleViewProperties *) newBubbleViewProperties;
+ (CGFloat) heightForImageSize:(CGSize) imageSize widht:(CGFloat) width;
+ (CGFloat) heightForImage:(UIImage *) image widht:(CGFloat) width;
@end
