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
@property (nonatomic,strong) UIImage *backgroundImage;
@property (nonatomic,strong) UIView *messageBody;
@property (nonatomic,strong) UILabel *messageLeftHeader;
@property (nonatomic,strong) UILabel *messageRightHeader;
@property (nonatomic,strong) VKBubbleViewProperties *properties;

- (CGFloat) estimatedWidthWithMaximumWidth:(CGFloat) maximimWidth;

- (id) initWithProperties:(VKBubbleViewProperties *) properties;
@end
