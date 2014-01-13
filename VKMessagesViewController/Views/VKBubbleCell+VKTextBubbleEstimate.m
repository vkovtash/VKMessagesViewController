//
//  VKBubbleCell+VKTextBubbleEstimate.m
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 13/01/14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKBubbleCell+VKTextBubbleEstimate.h"

@implementation VKBubbleCell (VKTextBubbleEstimate)

+ (CGFloat) estimatedHeightForText:(NSString *) text Widht:(CGFloat) width BubbleProperties:(VKTextBubbleViewProperties *) properties{
    UIEdgeInsets insets = [[self class] edgeInsets];
    return insets.top + insets.bottom + [properties estimatedSizeForText:text
                                                                   Widht:width*[[self class] bubbleViewWidthMultiplier]-insets.right-insets.left].height;
}

@end
