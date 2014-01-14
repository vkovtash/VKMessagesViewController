//
//  VKBobbleViewProperties.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKBubbleViewProperties.h"

static const CGFloat kViewMinimumWidth = 180;

@interface VKBubbleViewProperties()
@end

@implementation VKBubbleViewProperties

- (id) initWithHeaderFont:(UIFont *) headerFont EdgeInsets:(UIEdgeInsets) edgeInsets {
    self = [super init];
    if (self) {
        self.headerFont = headerFont;
        self.edgeInsets = edgeInsets;
        self.minimumWidth = 180;
    }
    return self;
}

- (id) init {
    return [self initWithHeaderFont:[UIFont systemFontOfSize:12] EdgeInsets:UIEdgeInsetsMake(4, 10, 4, 10)];
}

- (CGFloat) estimatedHeaderHeigth{
    NSString static *VKMessageDummyHeaderText = @"Header text";
    CGSize headerSize = [VKMessageDummyHeaderText sizeWithFont:self.headerFont
                                                      forWidth:self.minimumWidth
                                                 lineBreakMode:NSLineBreakByTruncatingTail];
    return headerSize.height;
}

@end
