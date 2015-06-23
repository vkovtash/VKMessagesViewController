//
//  VKOutboundTextBubbleCell.m
//  VKMessagesViewController
//
//  Created by kovtash on 04.02.14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKOutboundTextBubbleCell.h"

static CGFloat kBodyFontSyze = 14;
static CGFloat kMinimumWidth = 40;

NSString *VKOutboundTextBubbleCellReuseIdentifier =  @"VKOutboundTextBubbleCell";

@implementation VKOutboundTextBubbleCell
@dynamic bubbleView;

+ (VKTextBubbleViewProperties *) newBubbleViewProperties {
    static VKTextBubbleViewProperties *bubbleViewProperties = nil;
    if (!bubbleViewProperties) {
        bubbleViewProperties = [[VKTextBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 14)
                                                                                 font:[UIFont systemFontOfSize:kBodyFontSyze]
                                                                            textColor:[UIColor whiteColor]];
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
