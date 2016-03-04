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
@property (nonatomic, strong) UIImage *normalBackgroundImage;
@property (nonatomic, strong) UIImage *selectedBackgroundImage;
@property (readonly, nonatomic) UIView *messageBody;
@property (nonatomic,strong) VKBubbleViewProperties *properties;
@property (readonly, nonatomic) BOOL isSelected;

- (void)setSelected:(BOOL) selected;
- (CGSize)sizeConstrainedToWidth:(CGFloat) width;

- (instancetype)initWithBubbleProperties:(VKBubbleViewProperties *)properties;
@end
