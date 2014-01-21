//
//  VKDefaultBubbleCell+VKImageBubbleCell.m
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 15/01/14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKDefaultBubbleCell+VKImageBubbleCell.h"
#import "VKiOSVersionCheck.h"
#import "VKDefaultBubbleCell.h"
#import "VKBubbleView+VKDefaultBubbleView.h"

NSString *VKInboundImageBubbleCellReuseIdentifier = @"VKInboundImageBubbleCell";
NSString *VKOutboundImageBubbleCellReuseIdentifier = @"VKOutboundImageBubbleCell";
static CGFloat kMinimumWidth = 40;
static CGFloat kMaximumSize = 230;

@implementation VKDefaultBubbleCell (VKImageBubbleCell)

+ (VKImageBubbleViewProperties *) inboundImageBubbleViewProperties {
    static VKImageBubbleViewProperties *inboundImageBubbleViewProperties = nil;
    if (!inboundImageBubbleViewProperties) {
        if (SYSTEM_VERSION_LESS_THAN(@"7")) {
            inboundImageBubbleViewProperties = [[VKImageBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(2, 7, 5, 3)
                                                                                               maxSize:kMaximumSize];
        }
        else {
            inboundImageBubbleViewProperties = [[VKImageBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(2, 7, 2, 2)
                                                                                               maxSize:kMaximumSize];
        }
        inboundImageBubbleViewProperties.minimumWidth = kMinimumWidth;
    }
    return inboundImageBubbleViewProperties;
}

+ (VKImageBubbleViewProperties *) outboundImageBubbleViewProperties {
    static VKImageBubbleViewProperties *outboundImageBubbleViewProperties = nil;
    if (!outboundImageBubbleViewProperties) {
        if (SYSTEM_VERSION_LESS_THAN(@"7")) {
            outboundImageBubbleViewProperties = [[VKImageBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(2, 3, 5, 7)
                                                                                                maxSize:kMaximumSize];
        }
        else {
            outboundImageBubbleViewProperties = [[VKImageBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 7)
                                                                                                maxSize:kMaximumSize];
        }
        outboundImageBubbleViewProperties.minimumWidth = kMinimumWidth;
    }
    return outboundImageBubbleViewProperties;
}

+ (VKDefaultBubbleCell *) newInboundImageBubbleCell {
    VKImageBubbleView *imageBubbleView = [VKImageBubbleView inboundBubbleWithProperties:[[self class] inboundImageBubbleViewProperties]];
    if (SYSTEM_VERSION_LESS_THAN(@"7")) {
        imageBubbleView.messageBody.layer.cornerRadius = 5;
    }
    else {
        imageBubbleView.messageBody.layer.cornerRadius = 16;
    }
    imageBubbleView.messageBody.clipsToBounds = YES;
    return [VKDefaultBubbleCell inboundCellWithBubbleView:imageBubbleView
                                          reuseIdentifier:VKInboundImageBubbleCellReuseIdentifier];
}

+ (VKDefaultBubbleCell *) newOutboundImageBubbleCell {
    VKImageBubbleView *imageBubbleView = [VKImageBubbleView outboundBubbleWithProperties:[[self class] outboundImageBubbleViewProperties]];
    if (SYSTEM_VERSION_LESS_THAN(@"7")) {
        imageBubbleView.messageBody.layer.cornerRadius = 5;
    }
    else {
        imageBubbleView.messageBody.layer.cornerRadius = 16;
    }
    imageBubbleView.messageBody.clipsToBounds = YES;
    return [VKDefaultBubbleCell outboundCellWithBubbleView:imageBubbleView
                                           reuseIdentifier:VKOutboundImageBubbleCellReuseIdentifier];
}

+ (CGFloat) heightForInboundImageBubbleCell:(UIImage *) image Widht:(CGFloat) width {
    return [self estimatedHeightForImage:image
                                   Widht:width
                        BubbleProperties:[[self class] inboundImageBubbleViewProperties]];
}

+ (CGFloat) heightForOutboundImageBubbleCell:(UIImage *) image Widht:(CGFloat) width {
    return [self estimatedHeightForImage:image
                                   Widht:width
                        BubbleProperties:[[self class] outboundImageBubbleViewProperties]];
}

+ (CGFloat) heightForInboundBubbleCellWithImage:(UIImage *) image widht:(CGFloat) width {
    return [[self class] estimatedHeightForImage:image
                                           Widht:width
                                BubbleProperties:[[self class] inboundImageBubbleViewProperties]];
}

+ (CGFloat) heightForOutboundBubbleCellWithImage:(UIImage *) image widht:(CGFloat) width {
    return [[self class] estimatedHeightForImage:image
                                           Widht:width
                                BubbleProperties:[[self class] outboundImageBubbleViewProperties]];
}

+ (CGFloat) heightForInboundBubbleCellWithImageSize:(CGSize) imageSize widht:(CGFloat) width {
    return [[self class] estimatedHeightForImageSize:imageSize
                                               Widht:width
                                    BubbleProperties:[[self class] inboundImageBubbleViewProperties]];
}

+ (CGFloat) heightForOutboundBubbleCellWithImageSize:(CGSize) imageSize widht:(CGFloat) width {
    return [[self class] estimatedHeightForImageSize:imageSize
                                               Widht:width
                                    BubbleProperties:[[self class] outboundImageBubbleViewProperties]];
}

+ (CGFloat) estimatedHeightForImageSize:(CGSize) imageSize Widht:(CGFloat) width BubbleProperties:(VKImageBubbleViewProperties *) properties{
    UIEdgeInsets insets = [[self class] edgeInsets];
    return insets.top + insets.bottom + [VKImageBubbleView sizeWithImageSize:imageSize
                                                              Properties:properties
                                                      constrainedToWidth:[[self class] bubbleViewWidthConstraintForCellWidth:width]].height;
}

+ (CGFloat) estimatedHeightForImage:(UIImage *) image Widht:(CGFloat) width BubbleProperties:(VKImageBubbleViewProperties *) properties{
    if (image) {
        return [[self class] estimatedHeightForImageSize:image.size
                                                   Widht:width
                                        BubbleProperties:properties];
    }
    else {
        return [[self class] estimatedHeightForImageSize:CGSizeZero
                                                   Widht:width
                                        BubbleProperties:properties];
    }
}

+ (VKDefaultBubbleCell *) getInboundImageMessageCell:(UITableView *) tableView {
    VKDefaultBubbleCell *messageCell = [tableView dequeueReusableCellWithIdentifier:VKInboundImageBubbleCellReuseIdentifier];
    if (messageCell == nil) {
        messageCell = [VKDefaultBubbleCell newInboundImageBubbleCell];
    }
    return messageCell;
}

+ (VKDefaultBubbleCell *) getOutboundImageMessageCell:(UITableView *) tableView {
    VKDefaultBubbleCell *messageCell = [tableView dequeueReusableCellWithIdentifier:VKOutboundImageBubbleCellReuseIdentifier];
    if (messageCell == nil) {
        messageCell = [VKDefaultBubbleCell newOutboundImageBubbleCell];
    }
    return messageCell;
}

@end
