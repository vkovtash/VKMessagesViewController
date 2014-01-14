//
//  VKTextBubbleViewProperties.m
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 26/12/13.
//  Copyright (c) 2013 kovtash.com. All rights reserved.
//

#import "VKTextBubbleViewProperties.h"

@interface VKTextBubbleViewProperties()
@end

@implementation VKTextBubbleViewProperties

- (id) initWithHeaderFont:(UIFont *) headerFont BodyFont:(UIFont *) bodyFont EdgeInsets:(UIEdgeInsets) edgeInsets {
    self = [super init];
    if (self) {
        self.headerFont = headerFont;
        self.bodyFont = bodyFont;
        self.edgeInsets = edgeInsets;
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.bodyFont = [UIFont systemFontOfSize:14];
    }
    return self;
}

@end













