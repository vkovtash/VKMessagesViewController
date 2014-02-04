//
//  VKOutboundImageBubbleCell.m
//  VKMessagesViewController
//
//  Created by kovtash on 04.02.14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKOutboundImageBubbleCell.h"
#import "VKiOSVersionCheck.h"
#import <QuartzCore/QuartzCore.h>

NSString *VKOutboundImageBubbleCellReuseIdentifier = @"VKOutboundImageBubbleCell";

static CGFloat kMinimumWidth = 40;
static CGFloat kMaximumSize = 230;

@implementation VKOutboundImageBubbleCell

+ (VKImageBubbleViewProperties *) newBubbleViewProperties {
    static VKImageBubbleViewProperties *bubbleViewProperties = nil;
    if (!bubbleViewProperties) {
        if (SYSTEM_VERSION_LESS_THAN(@"7")) {
            bubbleViewProperties = [[VKImageBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(2, 3, 5, 7)
                                                                                                maxSize:kMaximumSize];
        }
        else {
            bubbleViewProperties = [[VKImageBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 7)
                                                                                                maxSize:kMaximumSize];
        }
        bubbleViewProperties.minimumWidth = kMinimumWidth;
    }
    return bubbleViewProperties;
}

+ (VKImageBubbleView *) newBubbleView {
    return [[VKImageBubbleView alloc] initWithBubbleProperties:[[self class] newBubbleViewProperties]];
}

+ (CGFloat) heightForImageSize:(CGSize) imageSize widht:(CGFloat) width {
    UIEdgeInsets insets = [[self class] edgeInsets];
    return insets.top + insets.bottom + [VKImageBubbleView sizeWithImageSize:imageSize
                                                                  Properties:[[self class] newBubbleViewProperties]
                                                          constrainedToWidth:[[self class] bubbleViewWidthConstraintForCellWidth:width]].height;
}

+ (CGFloat) heightForImage:(UIImage *) image widht:(CGFloat) width {
    if (image) {
        return [[self class] heightForImageSize:image.size widht:width];
    }
    else {
        return [[self class] heightForImageSize:CGSizeZero widht:width];
    }
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (SYSTEM_VERSION_LESS_THAN(@"7")) {
            self.bubbleView.messageBody.layer.cornerRadius = 5;
        }
        else {
            self.bubbleView.messageBody.layer.cornerRadius = 16;
        }
        self.bubbleView.messageBody.clipsToBounds = YES;
    }
    return self;
}

@end
