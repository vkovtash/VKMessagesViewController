//
//  VKInboundTextBubbleCell.m
//  VKMessagesViewController
//
//  Created by kovtash on 04.02.14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKInboundTextBubbleCell.h"
#import "VKTextBubbleViewProperties.h"
#import "VKiOSVersionCheck.h"

static CGFloat const kBodyFontSyze = 14;
static CGFloat const kMinimumWidth = 40;

NSString *VKInboundTextBubbleCellReuseIdentifier =  @"VKInboundTextBubbleCell";

@implementation VKInboundTextBubbleCell

+ (VKTextBubbleViewProperties *) newBubbleViewProperties {
    static VKTextBubbleViewProperties *bubbleViewProperties = nil;
    if (!bubbleViewProperties) {
        if (SYSTEM_VERSION_LESS_THAN(@"7")) {
            bubbleViewProperties = [[VKTextBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(4, 8, 4, 4)
                                                                                            bodyFont:[UIFont systemFontOfSize:kBodyFontSyze]];
        }
        else {
            bubbleViewProperties = [[VKTextBubbleViewProperties alloc] initWithEdgeInsets:UIEdgeInsetsMake(8, 14, 8, 10)
                                                                                            bodyFont:[UIFont systemFontOfSize:kBodyFontSyze]];
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
        self.bubbleView.messageBody.textColor = [UIColor darkGrayColor];
    }
    return self;
}

@end
