//
//  VKBaseBubbleCell.h
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 13/01/14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKBubbleCell.h"

@interface VKBaseBubbleCell : VKBubbleCell
@property (strong, nonatomic) NSDate *messageDate;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (readwrite, nonatomic) NSString *messageState;

+ (instancetype) inboundCellWithBubbleView:(VKBubbleView *) bubbleView reuseIdentifier:(NSString *) reuseIdentifier;
+ (instancetype) outboundCellWithBubbleView:(VKBubbleView *) bubbleView reuseIdentifier:(NSString *) reuseIdentifier;
+ (CGFloat) bubbleViewWidthConstraintForCellWidth:(CGFloat) cellWidth;

//class constants
+ (UIEdgeInsets) edgeInsets;
@end
