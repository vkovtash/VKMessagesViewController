//
//  VKBubbleView+VKDefaultBubbleView.h
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 13/01/14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKBubbleView.h"

@interface VKBubbleView (VKDefaultBubbleView)
+ (UIImage *) inboundBackgroudImage;
+ (UIImage *) outboundBackgroudImage;
+ (UIImage *) inboundSelectedBackgroudImage;
+ (UIImage *) outboundSelectedBackgroudImage;
+ (instancetype) inboundBubbleWithProperties:(VKBubbleViewProperties *) properties;
+ (instancetype) outboundBubbleWithProperties:(VKBubbleViewProperties *) properties;
@end