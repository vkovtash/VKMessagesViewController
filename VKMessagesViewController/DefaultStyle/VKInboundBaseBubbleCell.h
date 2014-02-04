//
//  VKDefaultInboundBubbleCell.h
//  VKMessagesViewController
//
//  Created by kovtash on 04.02.14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKDefaultBubbleCell.h"

@interface VKInboundBaseBubbleCell : VKDefaultBubbleCell

+ (UIImage *) backgroudImage;
+ (UIImage *) selectedBackgroudImage;
+ (VKBubbleView *) newBubbleView;
+ (VKBubbleViewProperties *) newBubbleViewProperties;
@end
