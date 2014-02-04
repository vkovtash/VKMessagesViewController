//
//  VKBaseBubbleCell.h
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 13/01/14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKBubbleCell.h"

@interface VKDefaultBubbleCell : VKBubbleCell
@property (readonly, nonatomic) UILabel *messageDetails;
@property (readonly, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDate *messageDate;
@property (strong, nonatomic) NSString *messageState;
@property (strong, nonatomic) UIView *bubbleAccessoryView;

+ (CGFloat) bubbleViewWidthConstraintForCellWidth:(CGFloat) cellWidth;

//class constants
+ (UIEdgeInsets) edgeInsets;
@end
