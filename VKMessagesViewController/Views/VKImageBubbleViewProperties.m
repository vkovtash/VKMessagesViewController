//
//  VKImageBubbleViewProperties.m
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 16/01/14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKImageBubbleViewProperties.h"

static CGFloat kVKImageBubbleMaxSize = 230;

@implementation VKImageBubbleViewProperties

- (instancetype) initWithEdgeInsets:(UIEdgeInsets)edgeInsets maxSize:(CGFloat) maxSize {
    self = [super initWithEdgeInsets:edgeInsets];
    if (self) {
        _maxSize = maxSize;
    }
    return self;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        _maxSize = kVKImageBubbleMaxSize;
    }
    return self;
}

@end
