//
//  VKBubbleCell.h
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKBubbleView.h"
#import "VKTextBubbleViewProperties.h"

typedef enum VKMessageCellStyle{
    VKMessageCellStyleNormal,
    VKMessageCellStyleSelected
} VKMessageCellStyle;

typedef enum VKBubbleAlign{
    VKBubbleAlignLeft,
    VKBubbleAlignRight
} VKBubbleAlign;

@interface VKBubbleCell : UITableViewCell
@property (nonatomic,strong) VKBubbleView *bubbleView;
@property (nonatomic) VKMessageCellStyle cellStyle;
@property (nonatomic) VKBubbleAlign bubbleAlign;
@property (strong, nonatomic) NSDate *messageDate;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (readwrite, nonatomic) NSString *messageLeftHeader;

- (id) initWithBubbleView:(VKBubbleView *) bubbleView reuseIdentifier:(NSString *) reuseIdentifier;
- (void) setBackgroundImage:(UIImage *) image forStyle:(VKMessageCellStyle) style;
+ (CGFloat) bubbleViewWidthMultiplier; //cell text width multiplier
+ (UIEdgeInsets) edgeInsets;
@end
