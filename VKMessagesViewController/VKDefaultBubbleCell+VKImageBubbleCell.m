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

@implementation VKDefaultBubbleCell (VKImageBubbleCell)

+ (VKBubbleViewProperties *) inboundImageBubbleViewProperties {
    static VKBubbleViewProperties *inboundImageBubbleViewProperties = nil;
    if (!inboundImageBubbleViewProperties) {
        if (SYSTEM_VERSION_LESS_THAN(@"7")) {
            inboundImageBubbleViewProperties = [[VKBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(6, 6, 7, 2)];
        }
        else {
            inboundImageBubbleViewProperties = [[VKBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(16, 6, 16, 0)];
        }
        inboundImageBubbleViewProperties.minimumWidth = 40;
    }
    return inboundImageBubbleViewProperties;
}

+ (VKBubbleViewProperties *) outboundImageBubbleViewProperties {
    static VKBubbleViewProperties *outboundImageBubbleViewProperties = nil;
    if (!outboundImageBubbleViewProperties) {
        if (SYSTEM_VERSION_LESS_THAN(@"7")) {
            outboundImageBubbleViewProperties = [[VKBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(6, 2, 7, 6)];
        }
        else {
            outboundImageBubbleViewProperties = [[VKBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(16, 0, 16, 5)];
        }
        outboundImageBubbleViewProperties.minimumWidth = 40;
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

+ (CGFloat) estimatedHeightForImage:(UIImage *) image Widht:(CGFloat) width BubbleProperties:(VKBubbleViewProperties *) properties{
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
