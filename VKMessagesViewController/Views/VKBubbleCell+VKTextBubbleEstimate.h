//
//  VKBubbleCell+VKTextBubbleEstimate.h
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 13/01/14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKBubbleCell.h"

@interface VKBubbleCell (VKTextBubbleEstimate)

+ (CGFloat) estimatedHeightForText:(NSString *) text Widht:(CGFloat) width BubbleProperties:(VKTextBubbleViewProperties *) properties;

@end
