//
//  VKTextBubbleView.m
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 24/12/13.
//  Copyright (c) 2013 kovtash.com. All rights reserved.
//

#import "VKTextBubbleView.h"

static const CGFloat kViewMaxHeight = 9999;


@implementation VKTextBubbleView
@synthesize messageBody = _messageBody;

- (instancetype) initWithBubbleProperties:(VKTextBubbleViewProperties *)properties {
    self = [super initWithBubbleProperties:properties];
    return self;
}

- (TTTAttributedLabel *) messageBody {
    if (!_messageBody) {
        _messageBody = [[TTTAttributedLabel alloc] init];
        _messageBody.enabledTextCheckingTypes = NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber;
        _messageBody.delegate = self;
        _messageBody.backgroundColor = [UIColor clearColor];
        _messageBody.lineBreakMode = self.properties.lineBreakMode;
        _messageBody.numberOfLines = 0;
    }
    return _messageBody;
}

- (void) setProperties:(VKBubbleViewProperties *)properties {
    [super setProperties:properties];
    self.messageBody.font = self.properties.bodyFont;
}

- (CGFloat) widthConstrainedToWidth:(CGFloat) width {
    return [[self class] sizeWithAttributedString:self.messageBody.attributedText
                                       Properties:self.properties
                               constrainedToWidth:width].width;
 }

#pragma mark - class methods

+ (CGSize) sizeWithAttributedString:(NSAttributedString *) attributedString
                         Properties:(VKTextBubbleViewProperties *) properties
                 constrainedToWidth:(CGFloat) width {
    CGSize bodySize = CGSizeZero;
    
    if (attributedString) {
        bodySize = [TTTAttributedLabel sizeThatFitsAttributedString:attributedString
                                                    withConstraints:CGSizeMake(width - properties.edgeInsets.left - properties.edgeInsets.right, kViewMaxHeight)
                                             limitedToNumberOfLines:0];
    }
    
    bodySize.width += (properties.edgeInsets.left + properties.edgeInsets.right);
    bodySize.height += (properties.edgeInsets.top + properties.edgeInsets.bottom);
    if (bodySize.width < properties.minimumWidth) {
        bodySize.width = properties.minimumWidth;
    }
    return bodySize;
}

+ (CGSize) sizeWithText:(NSString *) text
             Properties:(VKTextBubbleViewProperties *) properties
      constrainedToWidth:(CGFloat) width {
    
    NSAttributedString *attributedString = nil;
    if (text) {
        attributedString = [[NSAttributedString alloc] initWithString:text
                                                           attributes:properties.textAttributes];
    }
    
    return [[self class] sizeWithAttributedString:attributedString
                                       Properties:properties
                               constrainedToWidth:width];
}

#pragma mark - UIResponderStandardEditActions

- (void)copy:(id)sender {
    [[UIPasteboard generalPasteboard] setString:self.messageBody.text];
}

@end
