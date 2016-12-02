//
//  VKBobbleViewProperties.h
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKBubbleViewProperties : NSObject
@property (nonatomic) UIEdgeInsets edgeInsets;
@property (nonatomic) CGFloat minimumWidth;
@property (nonatomic) CGFloat minimumHeight;

- (instancetype)initWithEdgeInsets:(UIEdgeInsets)edgeInsets;
@end
