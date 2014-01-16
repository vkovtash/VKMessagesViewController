//
//  VKDefaultBubbleCell+VKTextBubbleCell.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 13/01/14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKDefaultBubbleCell+VKTextBubbleCell.h"
#import "VKiOSVersionCheck.h"
#import "VKDefaultBubbleCell.h"
#import "VKBubbleView+VKDefaultBubbleView.h"

NSString *VKInboundTextBubbleCellReuseIdentifier =  @"VKInboundTextBubbleCell";
NSString *VKOutboundTextBubbleCellReuseIdentifier =  @"VKOutboundTextBubbleCell";

static CGFloat kBodyFontSyze = 12;
static CGFloat kMinimumWidth = 40;

@implementation VKBubbleCell (VKTextBubbleCell)

+ (VKTextBubbleViewProperties *) inboundTextBubbleViewProperties {
    static VKTextBubbleViewProperties *inboundTextBubbleViewProperties = nil;
    if (!inboundTextBubbleViewProperties) {
        if (SYSTEM_VERSION_LESS_THAN(@"7")) {
            inboundTextBubbleViewProperties = [[VKTextBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(4, 8, 4, 4)
                                                                                            bodyFont:[UIFont systemFontOfSize:kBodyFontSyze]];
        }
        else {
            inboundTextBubbleViewProperties = [[VKTextBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(8, 14, 8, 10)
                                                                                            bodyFont:[UIFont systemFontOfSize:kBodyFontSyze]];
        }
        inboundTextBubbleViewProperties.minimumWidth = kMinimumWidth;
    }
    return inboundTextBubbleViewProperties;
}

+ (VKTextBubbleViewProperties *) outboundTextBubbleViewProperties {
    static VKTextBubbleViewProperties *outboundTextBubbleViewProperties = nil;
    if (!outboundTextBubbleViewProperties) {
        if (SYSTEM_VERSION_LESS_THAN(@"7")) {
            outboundTextBubbleViewProperties = [[VKTextBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 8)
                                                                                             bodyFont:[UIFont systemFontOfSize:kBodyFontSyze]];
            
        }
        else {
            outboundTextBubbleViewProperties = [[VKTextBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(8, 10, 8, 14)
                                                                                             bodyFont:[UIFont systemFontOfSize:kBodyFontSyze]];
        }
        outboundTextBubbleViewProperties.minimumWidth = kMinimumWidth;
    }
    return outboundTextBubbleViewProperties;
}

+ (VKDefaultBubbleCell *) newInboundTextBubbleCell {
    VKTextBubbleView *textBubbleView = [VKTextBubbleView inboundBubbleWithProperties:[[self class] inboundTextBubbleViewProperties]];
    textBubbleView.messageBody.textColor = [UIColor darkGrayColor];
    return [VKDefaultBubbleCell inboundCellWithBubbleView:textBubbleView
                                       reuseIdentifier:VKInboundTextBubbleCellReuseIdentifier];
}

+ (VKDefaultBubbleCell *) newOutboundTextBubbleCell {
    VKTextBubbleView *textBubbleView = [VKTextBubbleView outboundBubbleWithProperties:[[self class] outboundTextBubbleViewProperties]];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        textBubbleView.messageBody.textColor = [UIColor whiteColor];
    }
    else {
        textBubbleView.messageBody.textColor = [UIColor darkGrayColor];
    }
    return [VKDefaultBubbleCell outboundCellWithBubbleView:textBubbleView
                                       reuseIdentifier:VKOutboundTextBubbleCellReuseIdentifier];
}

+ (CGFloat) heightForInboundTextBubbleCell:(NSString *) text Widht:(CGFloat) width {
    return [self estimatedHeightForText:text Widht:width BubbleProperties:[[self class] inboundTextBubbleViewProperties]];
}

+ (CGFloat) heightForOutboundTextBubbleCell:(NSString *) text Widht:(CGFloat) width {
    return [self estimatedHeightForText:text Widht:width BubbleProperties:[[self class] outboundTextBubbleViewProperties]];
}

+ (CGFloat) estimatedHeightForText:(NSString *) text Widht:(CGFloat) width BubbleProperties:(VKTextBubbleViewProperties *) properties{
    UIEdgeInsets insets = [[self class] edgeInsets];
    return insets.top + insets.bottom + [VKTextBubbleView sizeWithText:text
                                                            Properties:properties
                                                    constrainedToWidth:[[self class] bubbleViewWidthConstraintForCellWidth:width]].height;
}

+ (VKDefaultBubbleCell *) getInboundTextMessageCell:(UITableView *) tableView {
    VKDefaultBubbleCell *messageCell = [tableView dequeueReusableCellWithIdentifier:VKInboundTextBubbleCellReuseIdentifier];
    if (messageCell == nil) {
        messageCell = [VKDefaultBubbleCell newInboundTextBubbleCell];
    }
    return messageCell;
}

+ (VKDefaultBubbleCell *) getOutboundTextMessageCell:(UITableView *) tableView {
    VKDefaultBubbleCell *messageCell = [tableView dequeueReusableCellWithIdentifier:VKOutboundTextBubbleCellReuseIdentifier];
    if (messageCell == nil) {
        messageCell = [VKDefaultBubbleCell newOutboundTextBubbleCell];
    }
    return messageCell;
}

@end




















