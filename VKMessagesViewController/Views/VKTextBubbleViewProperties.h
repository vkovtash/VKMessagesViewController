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
@property (nonatomic) NSLineBreakMode lineBreakMode;
@property (nonatomic, readonly) NSDictionary *textAttributes;

- (instancetype) initWithEdgeInsets:(UIEdgeInsets)edgeInsets font:(UIFont *) font textColor:(UIColor *) textColor;
@end
