//
//  VKImageBubbleViewProperties.h
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 16/01/14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKBubbleViewProperties.h"

@interface VKImageBubbleViewProperties : VKBubbleViewProperties
@property (nonatomic) CGFloat maxSize;

- (instancetype)initWithEdgeInsets:(UIEdgeInsets)edgeInsets maxSize:(CGFloat)maxSize;

- (CGSize)sizeWithImageSize:(CGSize)imageSize constrainedToWidth:(CGFloat)width;
- (CGSize)sizeWithImage:(UIImage *)image constrainedToWidth:(CGFloat)width;
@end
