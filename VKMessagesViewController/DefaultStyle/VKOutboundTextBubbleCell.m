//
//  VKOutboundTextBubbleCell.m
//  VKMessagesViewController
//
//  Created by kovtash on 04.02.14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKOutboundTextBubbleCell.h"
#import "VKiOSVersionCheck.h"

static CGFloat kBodyFontSyze = 14;
static CGFloat kMinimumWidth = 40;

NSString *VKOutboundTextBubbleCellReuseIdentifier =  @"VKOutboundTextBubbleCell";

@implementation VKOutboundTextBubbleCell

+ (VKTextBubbleViewProperties *) newBubbleViewProperties {
    static VKTextBubbleViewProperties *bubbleViewProperties = nil;
    if (!bubbleViewProperties) {
        if (SYSTEM_VERSION_LESS_THAN(@"7")) {
            bubbleViewProperties = [[VKTextBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 8)
                                                                                     font:[UIFont systemFontOfSize:kBodyFontSyze]
                                                                                textColor:[UIColor whiteColor]];
        }
        else {
            bubbleViewProperties = [[VKTextBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(8, 10, 8, 14)
                                                                                     font:[UIFont systemFontOfSize:kBodyFontSyze]
                                                                                textColor:[UIColor darkGrayColor]];
        }
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

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bubbleView.messageBody.textColor = [UIColor whiteColor];
    }
    return self;
}

- (void) setMessageText:(NSString *)messageText {
    self.bubbleView.messageBody.text = messageText;
}

- (NSString *) messageText {
    return self.bubbleView.messageBody.text;
}

@end
