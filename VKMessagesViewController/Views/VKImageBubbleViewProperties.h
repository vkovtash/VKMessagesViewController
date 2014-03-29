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

- (instancetype) initWithEdgeInsets:(UIEdgeInsets)edgeInsets maxSize:(CGFloat) maxSize;
@end
