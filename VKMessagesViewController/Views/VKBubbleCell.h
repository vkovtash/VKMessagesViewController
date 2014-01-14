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

typedef enum VKBubbleAlign{
    VKBubbleAlignLeft,
    VKBubbleAlignRight
} VKBubbleAlign;

@interface VKBubbleCell : UITableViewCell
@property (nonatomic,strong) VKBubbleView *bubbleView;
@property (nonatomic) VKBubbleAlign bubbleAlign;
@property (readwrite, nonatomic) NSString *messageLeftHeader;
@property (readwrite, nonatomic) NSString *messageRightHeader;

- (void) applyLayout;
- (id) initWithBubbleView:(VKBubbleView *) bubbleView reuseIdentifier:(NSString *) reuseIdentifier;
+ (CGFloat) bubbleViewWidthMultiplier; //cell text width multiplier
+ (UIEdgeInsets) edgeInsets;
@end
