//
//  VKTextBubbleViewProperties.m
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 26/12/13.
//  Copyright (c) 2013 kovtash.com. All rights reserved.
//

#import "VKTextBubbleViewProperties.h"

static CGFloat kDefaultBodyFont = 14;

@implementation VKTextBubbleViewProperties

- (id) initWithBodyFont:(UIFont *) bodyFont EdgeInsets:(UIEdgeInsets) edgeInsets {
    self = [super init];
    if (self) {
        self.bodyFont = bodyFont;
        self.edgeInsets = edgeInsets;
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.bodyFont = [UIFont systemFontOfSize:kDefaultBodyFont];
    }
    return self;
}

@end













