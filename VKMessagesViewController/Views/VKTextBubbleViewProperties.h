//
//  VKTextBubbleViewProperties.h
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 26/12/13.
//  Copyright (c) 2013 kovtash.com. All rights reserved.
//

#import "VKBubbleViewProperties.h"

@interface VKTextBubbleViewProperties : VKBubbleViewProperties
@property (readonly, nonatomic) UIFont *font;
@property (readonly, nonatomic) UIColor *textColor;
@property (readwrite, nonatomic) NSLineBreakMode lineBreakMode;
@property (readonly, nonatomic) NSDictionary *textAttributes;

- (instancetype)initWithEdgeInsets:(UIEdgeInsets)edgeInsets font:(UIFont *)font textColor:(UIColor *)textColor;

- (CGSize)sizeWithText:(NSString *)text constrainedToWidth:(CGFloat)width;
- (CGSize)sizeWithAttributedString:(NSAttributedString *)attributedString constrainedToWidth:(CGFloat)width;
@end
