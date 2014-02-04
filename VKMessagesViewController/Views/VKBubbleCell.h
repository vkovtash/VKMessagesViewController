//
//  VKBubbleCell.h
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKBubbleView.h"

typedef enum VKBubbleAlign{
    VKBubbleAlignLeft,
    VKBubbleAlignRight
} VKBubbleAlign;

@interface VKBubbleCell : UITableViewCell
@property (nonatomic, readonly) VKBubbleView *bubbleView;
@property (nonatomic) VKBubbleAlign bubbleAlign;
@property (nonatomic) UIEdgeInsets edgeInsets;
@property (nonatomic) CGFloat bubbleViewMaxWidth;

- (void) applyLayout;
- (id) initWithBubbleView:(VKBubbleView *) bubbleView reuseIdentifier:(NSString *) reuseIdentifier;
@end
