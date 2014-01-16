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
            inboundImageBubbleViewProperties = [[VKImageBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(6, 6, 7, 2)
                                                                                               maxSize:kMaximumSize];
        }
        else {
            inboundImageBubbleViewProperties = [[VKImageBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(16, 6, 16, 0)
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
            outboundImageBubbleViewProperties = [[VKImageBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(6, 2, 7, 6)
                                                                                                maxSize:kMaximumSize];
        }
        else {
            outboundImageBubbleViewProperties = [[VKImageBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(16, 0, 16, 5)
                                                                                                maxSize:kMaximumSize];
        }
        outboundImageBubbleViewProperties.minimumWidth = kMinimumWidth;
    }
    return outboundImageBubbleViewProperties;
}

+ (VKDefaultBubbleCell *) newInboundImageBubbleCell {
    VKImageBubbleView *imageBubbleView = [VKImageBubbleView inboundBubbleWithProperties:[[self class] inboundImageBubbleViewProperties]];
    return [VKDefaultBubbleCell inboundCellWithBubbleView:imageBubbleView
                                          reuseIdentifier:VKInboundImageBubbleCellReuseIdentifier];
}

+ (VKDefaultBubbleCell *) newOutboundImageBubbleCell {
    VKImageBubbleView *imageBubbleView = [VKImageBubbleView outboundBubbleWithProperties:[[self class] outboundImageBubbleViewProperties]];
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

+ (CGFloat) estimatedHeightForImage:(UIImage *) image Widht:(CGFloat) width BubbleProperties:(VKImageBubbleViewProperties *) properties{
    UIEdgeInsets insets = [[self class] edgeInsets];
    return insets.top + insets.bottom + [VKImageBubbleView sizeWithImage:image
                                                              Properties:properties
                                                      constrainedToWidth:[[self class] bubbleViewWidthConstraintForCellWidth:width]].height;
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
