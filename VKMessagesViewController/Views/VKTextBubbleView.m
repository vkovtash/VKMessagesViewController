//
//  VKTextBubbleView.m
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 24/12/13.
//  Copyright (c) 2013 kovtash.com. All rights reserved.
//

#import "VKTextBubbleView.h"

@implementation VKTextBubbleView

- (instancetype) initWithProperties:(VKTextBubbleViewProperties *)properties {
    self = [super initWithProperties:properties];
    return self;
}

- (UIView *) messageBody {
    return self.textBody;
}

- (CGFloat) estimatedWidthWithMaximumWidth:(CGFloat)maximimWidth {
    return [self.properties estimatedWidthForText:self.textBody.text Width:maximimWidth];
}

- (UILabel *) textBody{
    if (!_textBody) {
        TTTAttributedLabel *attributedLabel = [[TTTAttributedLabel alloc] init];
        attributedLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber;
        attributedLabel.delegate = self;
        _textBody = attributedLabel;
        _textBody.backgroundColor = [UIColor clearColor];
        _textBody.textColor = [UIColor darkGrayColor];
        _textBody.lineBreakMode = self.properties.lineBreakMode;
        _textBody.numberOfLines = 0;
    }
    return _textBody;
}

- (void) setProperties:(VKBubbleViewProperties *)properties {
    [super setProperties:properties];
    
    self.textBody.font = self.properties.bodyFont;
}

#pragma mark - UIResponderStandardEditActions

- (void)copy:(id)sender {
    [[UIPasteboard generalPasteboard] setString:self.textBody.text];
}

@end
