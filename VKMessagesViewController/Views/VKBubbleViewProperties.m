//
//  VKBobbleViewProperties.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKBubbleViewProperties.h"

static const CGFloat kViewMinimumWidth = 0;

@interface VKBubbleViewProperties()
@end

@implementation VKBubbleViewProperties

- (id) initWithEdgeInsets:(UIEdgeInsets) edgeInsets {
    self = [super init];
    if (self) {
        self.edgeInsets = edgeInsets;
        self.minimumWidth = kViewMinimumWidth;
    }
    return self;
}

- (id) init {
    return [self initWithEdgeInsets:UIEdgeInsetsMake(4, 10, 4, 10)];
}

@end
