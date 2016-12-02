//
//  VKTextBubbleViewProperties.m
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 26/12/13.
//  Copyright (c) 2013 kovtash.com. All rights reserved.
//

#import "VKTextBubbleViewProperties.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>

static CGFloat kDefaultBodyFont = 14;
static CGFloat const kViewMaxHeight = 9999;
static NSInteger const kTextPartsCount = 4;


@interface VKTextBubbleViewProperties()
@property (nonatomic, strong) NSMutableDictionary *privateTextAttributes;
@property (nonatomic, strong) NSMutableParagraphStyle *privateParagraphStyle;
@end

@implementation VKTextBubbleViewProperties

- (instancetype)initWithEdgeInsets:(UIEdgeInsets)edgeInsets font:(UIFont *)font textColor:(UIColor *)textColor {
    self = [super init];
    if (self) {
        self.font = font;
        self.textColor = textColor;
        self.edgeInsets = edgeInsets;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.font = [UIFont systemFontOfSize:kDefaultBodyFont];
    }
    return self;
}

- (NSParagraphStyle *)privateParagraphStyle {
    if (!_privateParagraphStyle) {
        _privateParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    }
    return _privateParagraphStyle;
}

- (NSMutableDictionary *)privateTextAttributes {
    if (!_privateTextAttributes) {
        _privateTextAttributes = [NSMutableDictionary dictionary];
        [_privateTextAttributes setObject:self.privateParagraphStyle
                                   forKey:NSParagraphStyleAttributeName];
    }
    return _privateTextAttributes;
}

- (NSDictionary *)textAttributes {
    return self.privateTextAttributes;
}

- (UIFont *)font {
    return [self.privateTextAttributes objectForKey:NSFontAttributeName];
}

- (void)setFont:(UIFont *)font {
    if (font) {
        [self.privateTextAttributes setObject:font forKey:NSFontAttributeName];
    }
    else {
        [self.privateTextAttributes removeObjectForKey:NSFontAttributeName];
    }
}

- (UIColor *)textColor {
    return [self.privateTextAttributes objectForKey:NSForegroundColorAttributeName];
}

- (void)setTextColor:(UIColor *)textColor {
    if (textColor) {
        [self.privateTextAttributes setObject:textColor forKey:NSForegroundColorAttributeName];
    }
    else {
        [self.privateTextAttributes removeObjectForKey:NSForegroundColorAttributeName];
    }
}

- (NSLineBreakMode)lineBreakMode {
    return self.privateParagraphStyle.lineBreakMode;
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    self.privateParagraphStyle.lineBreakMode = lineBreakMode;
}

- (CGSize)sizeWithAttributedString:(NSAttributedString *)attributedString constrainedToWidth:(CGFloat)width {
    if (attributedString.length == 0) {
        return CGSizeZero;
    }

    UIEdgeInsets insets = self.edgeInsets;

    CGSize bodySize = [TTTAttributedLabel sizeThatFitsAttributedString:attributedString
                                                       withConstraints:CGSizeMake(width - insets.left - insets.right, kViewMaxHeight)
                                                limitedToNumberOfLines:0];

    bodySize.height += (insets.top + insets.bottom);
    bodySize.width += (insets.left + insets.right);
    CGFloat partSize = ceilf((width+kTextPartsCount)/kTextPartsCount);
    bodySize.width = ceilf(bodySize.width/partSize) * partSize;

    bodySize.width = MIN(bodySize.width, width);
    bodySize.width = MAX(bodySize.width, self.minimumWidth);
    bodySize.height = MAX(bodySize.height, self.minimumHeight);
    return bodySize;
}

- (CGSize)sizeWithText:(NSString *)text constrainedToWidth:(CGFloat)width {
    if (text.length == 0) {
        return CGSizeZero;
    }

    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text attributes:self.textAttributes];
    return [self sizeWithAttributedString:attributedString constrainedToWidth:width];
}

@end
