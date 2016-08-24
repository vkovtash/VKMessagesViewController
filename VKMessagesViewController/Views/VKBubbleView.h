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


typedef CGPathRef(^VKPathBlock)(CGRect rect);

@protocol  VKBubbleViewBackgroudProtocol <NSObject>
@property (assign, nonatomic) BOOL isSelected;
@end


@interface VKBubbleImageBackground : UIImageView <VKBubbleViewBackgroudProtocol>
@property (strong, nonatomic) UIImage *normalBackgroundImage;
@property (strong, nonatomic) UIImage *selectedBackgroundImage;
@end


@interface VKBubblePathBackground : UIView <VKBubbleViewBackgroudProtocol>
@property (strong, nonatomic) UIColor *fillColor;
@property (strong, nonatomic) UIColor *borderColor;
@property (strong, nonatomic) UIColor *selectedFillColor;
@property (strong, nonatomic) UIColor *selectedBorderColor;
@property (assign, nonatomic) CGFloat borderWidth;
@property (strong, nonatomic) VKPathBlock pathBlock;
@end


@interface VKBubbleView : UIView <TTTAttributedLabelDelegate>
@property (strong, nonatomic) UIView<VKBubbleViewBackgroudProtocol> *background;
@property (readonly, nonatomic) UIView *messageBody;
@property (strong, nonatomic) VKBubbleViewProperties *properties;
@property (readonly, nonatomic) BOOL isSelected;
@property (assign, nonatomic) CGFloat clippingBorderWidth;
@property (strong, nonatomic) UIColor *clippingBorderColor;
@property (strong, nonatomic) VKPathBlock clippingPathBlock;

- (void)setSelected:(BOOL)selected;
- (CGSize)sizeConstrainedToWidth:(CGFloat) width;

- (instancetype)initWithBubbleProperties:(VKBubbleViewProperties *)properties;
@end
