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

- (CGFloat) widthConstrainedToWidth:(CGFloat) width {
    return [[self class] widthWithText:self.messageBody.text Properties:self.properties constrainedToWidth:width];
}

- (UILabel *) messageBody {
    if (!_messageBody) {
        TTTAttributedLabel *attributedLabel = [[TTTAttributedLabel alloc] init];
        attributedLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber;
        attributedLabel.delegate = self;
        _messageBody = attributedLabel;
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

#pragma mark - class methods

+ (CGSize) sizeWithText:(NSString *) text
             Properties:(VKTextBubbleViewProperties *) properties
      constrainedToWidth:(CGFloat) width {
    
    TTTAttributedLabel *etalonLabel = [[TTTAttributedLabel alloc] init];
    etalonLabel.numberOfLines = 0;
    etalonLabel.lineBreakMode = properties.lineBreakMode;
    etalonLabel.font = properties.bodyFont;
    
    etalonLabel.frame = CGRectMake(0, 0, width - properties.edgeInsets.left - properties.edgeInsets.right, kViewMaxHeight);
    etalonLabel.text = text;
    [etalonLabel sizeToFit];
    CGSize bodySize = etalonLabel.frame.size;
    bodySize.width += (properties.edgeInsets.left + properties.edgeInsets.right);
    bodySize.height += (properties.edgeInsets.top + properties.edgeInsets.bottom);
    if (bodySize.width < properties.minimumWidth) {
        bodySize.width = properties.minimumWidth;
    }
    return bodySize;
}

+ (CGFloat) widthWithText:(NSString *) text
               Properties:(VKTextBubbleViewProperties *) properties
       constrainedToWidth:(CGFloat) width {
    CGFloat resultWidth = [text sizeWithFont:properties.bodyFont
                           constrainedToSize:CGSizeMake(kViewMaxHeight, kViewMaxHeight)
                               lineBreakMode:properties.lineBreakMode].width;
    resultWidth += (properties.edgeInsets.left + properties.edgeInsets.right);
    resultWidth = ceilf(resultWidth);
    if (resultWidth < properties.minimumWidth) {
        resultWidth = properties.minimumWidth;
    }
    else if (resultWidth > width){
        resultWidth = width;
    }
    return resultWidth;
}

#pragma mark - UIResponderStandardEditActions

- (void)copy:(id)sender {
    [[UIPasteboard generalPasteboard] setString:self.messageBody.text];
}

@end
