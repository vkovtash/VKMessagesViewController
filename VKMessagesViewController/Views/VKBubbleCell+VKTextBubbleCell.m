//
//  VKBubbleCell+VKTextBubbleCell.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 13/01/14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKBubbleCell+VKTextBubbleCell.h"
#import "VKiOSVersionCheck.h"
#import "VKBaseBubbleCell.h"
#import "VKBubbleView+VKDefaultBubbleView.h"

NSString *VKInboundTextBubbleCellReuseIdentifier =  @"VKInboundTextBubbleCell";
NSString *VKOutboundTextBubbleCellReuseIdentifier =  @"VKOutboundTextBubbleCell";

@implementation VKBubbleCell (VKTextBubbleCell)

+ (VKTextBubbleViewProperties *) inboundTextBubbleViewProperties {
    static VKTextBubbleViewProperties *inboundTextBubbleViewProperties = nil;
    if (!inboundTextBubbleViewProperties) {
        if (SYSTEM_VERSION_LESS_THAN(@"7")) {
            inboundTextBubbleViewProperties = [VKTextBubbleViewProperties defaultProperties];
            inboundTextBubbleViewProperties.edgeInsets = UIEdgeInsetsMake(4, 8, 4, 4);
        }
        else {
            inboundTextBubbleViewProperties = [VKTextBubbleViewProperties defaultProperties];
            inboundTextBubbleViewProperties.edgeInsets = UIEdgeInsetsMake(4, 16, 4, 12);
        }
    }
    return inboundTextBubbleViewProperties;
}

+ (VKTextBubbleViewProperties *) outboundTextBubbleViewProperties {
    static VKTextBubbleViewProperties *outboundTextBubbleViewProperties = nil;
    if (!outboundTextBubbleViewProperties) {
        if (SYSTEM_VERSION_LESS_THAN(@"7")) {
            outboundTextBubbleViewProperties = [VKTextBubbleViewProperties defaultProperties];
            outboundTextBubbleViewProperties.edgeInsets = UIEdgeInsetsMake(4, 4, 4, 8);
        }
        else {
            outboundTextBubbleViewProperties = [VKTextBubbleViewProperties defaultProperties];
            outboundTextBubbleViewProperties.edgeInsets = UIEdgeInsetsMake(4, 12, 4, 16);
        }
    }
    return outboundTextBubbleViewProperties;
}

+ (VKBubbleCell *) newInboundTextBubbleCell {
    VKTextBubbleView *textBubbleView = [VKTextBubbleView inboundBubbleWithProperties:[[self class] inboundTextBubbleViewProperties]];
    textBubbleView.messageBody.textColor = [UIColor darkGrayColor];
    return [VKBaseBubbleCell inboundCellWithBubbleView:textBubbleView
                                       reuseIdentifier:VKInboundTextBubbleCellReuseIdentifier];
}

+ (VKBubbleCell *) newOutboundTextBubbleCell {
    VKTextBubbleView *textBubbleView = [VKTextBubbleView outboundBubbleWithProperties:[[self class] outboundTextBubbleViewProperties]];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        textBubbleView.messageBody.textColor = [UIColor whiteColor];
    }
    else {
        textBubbleView.messageBody.textColor = [UIColor darkGrayColor];
    }
    return [VKBaseBubbleCell outboundCellWithBubbleView:textBubbleView
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
                                                    constrainedToWidth:width*[[self class] bubbleViewWidthMultiplier]-insets.right-insets.left].height;
}

@end




















