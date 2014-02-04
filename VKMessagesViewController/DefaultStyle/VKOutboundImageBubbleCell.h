//
//  VKOutboundImageBubbleCell.h
//  VKMessagesViewController
//
//  Created by kovtash on 04.02.14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKOutboundBaseBubbleCell.h"
#import "VKImageBubbleView.h"

extern NSString *VKOutboundImageBubbleCellReuseIdentifier;

@interface VKOutboundImageBubbleCell : VKOutboundBaseBubbleCell
@property (nonatomic, readonly) VKImageBubbleView *bubbleView;

+ (VKImageBubbleView *) newBubbleView;
+ (VKImageBubbleViewProperties *) newBubbleViewProperties;
+ (CGFloat) heightForImageSize:(CGSize) imageSize widht:(CGFloat) width;
+ (CGFloat) heightForImage:(UIImage *) image widht:(CGFloat) width;
@end
