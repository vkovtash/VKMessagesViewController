//
//  VKBubbleView.h
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKBubbleViewProperties.h"
#import "TTTAttributedLabel.h"

@interface VKBubbleView : UIView <TTTAttributedLabelDelegate>
@property (nonatomic,strong) UIImage *normalBackgroundImage;
@property (nonatomic,strong) UIImage *selectedBackgroundImage;
@property (nonatomic,strong) UIView *messageBody;
@property (nonatomic,strong) UILabel *messageLeftHeader;
@property (nonatomic,strong) UILabel *messageRightHeader;
@property (nonatomic,strong) VKBubbleViewProperties *properties;
@property (readonly, nonatomic) BOOL isSelected;

- (void) setSelected:(BOOL) selected;

- (CGFloat) estimatedWidthWithMaximumWidth:(CGFloat) maximimWidth;
- (id) initWithBubbleProperties:(VKBubbleViewProperties *) properties;
@end
