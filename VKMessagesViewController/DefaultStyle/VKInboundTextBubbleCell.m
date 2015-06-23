//
//  VKInboundTextBubbleCell.m
//  VKMessagesViewController
//
//  Created by kovtash on 04.02.14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKInboundTextBubbleCell.h"
#import "VKTextBubbleViewProperties.h"

static CGFloat const kBodyFontSyze = 14;
static CGFloat const kMinimumWidth = 40;

NSString *VKInboundTextBubbleCellReuseIdentifier =  @"VKInboundTextBubbleCell";

@implementation VKInboundTextBubbleCell
@dynamic bubbleView;

+ (VKTextBubbleViewProperties *) newBubbleViewProperties {
    static VKTextBubbleViewProperties *bubbleViewProperties = nil;
    if (!bubbleViewProperties) {
        bubbleViewProperties = [[VKTextBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(10, 14, 10, 10)
                                                                                 font:[UIFont systemFontOfSize:kBodyFontSyze]
                                                                            textColor:[UIColor darkGrayColor]];
        bubbleViewProperties.minimumWidth = kMinimumWidth;
    }
    return bubbleViewProperties;
}

+ (VKTextBubbleView *) newBubbleView {
    return [[VKTextBubbleView alloc] initWithBubbleProperties:[[self class] newBubbleViewProperties]];
}

+ (CGFloat) heightForText:(NSString *) text widht:(CGFloat) width {
    UIEdgeInsets insets = [[self class] edgeInsets];
    return insets.top + insets.bottom + [VKTextBubbleView sizeWithText:text
                                                            Properties:[[self class] newBubbleViewProperties]
                                                    constrainedToWidth:[[self class] bubbleViewWidthConstraintForCellWidth:width]].height;
}

- (void) setMessageText:(NSString *)messageText {
    self.bubbleView.messageBody.text = [[NSAttributedString alloc] initWithString:messageText
                                                                       attributes:self.bubbleView.properties.textAttributes];
}

- (NSString *) messageText {
    return self.bubbleView.messageBody.text;
}

@end
