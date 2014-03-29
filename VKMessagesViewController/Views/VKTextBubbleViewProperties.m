//
//  VKTextBubbleViewProperties.m
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 26/12/13.
//  Copyright (c) 2013 kovtash.com. All rights reserved.
//

#import "VKTextBubbleViewProperties.h"

static CGFloat kDefaultBodyFont = 14;

@interface VKTextBubbleViewProperties()
@property (nonatomic, strong) NSMutableDictionary *privateTextAttributes;
@property (nonatomic, strong) NSMutableParagraphStyle *privateParagraphStyle;
@end

@implementation VKTextBubbleViewProperties

- (NSParagraphStyle *) privateParagraphStyle {
    if (!_privateParagraphStyle) {
        _privateParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    }
    return _privateParagraphStyle;
}

- (NSMutableDictionary *) privateTextAttributes {
    if (!_privateTextAttributes) {
        _privateTextAttributes = [NSMutableDictionary dictionary];
        [_privateTextAttributes setObject:self.privateParagraphStyle
                                   forKey:NSParagraphStyleAttributeName];
    }
    return _privateTextAttributes;
}

- (NSDictionary *) textAttributes {
    return self.privateTextAttributes;
}

- (UIFont *) font {
    return [self.privateTextAttributes objectForKey:NSFontAttributeName];
}

- (void) setFont:(UIFont *)font {
    if (font) {
        [self.privateTextAttributes setObject:font forKey:NSFontAttributeName];
    }
    else {
        [self.privateTextAttributes removeObjectForKey:NSFontAttributeName];
    }
}

-(UIColor *) textColor {
    return [self.privateTextAttributes objectForKey:NSForegroundColorAttributeName];
}

- (void) setTextColor:(UIColor *)textColor {
    if (textColor) {
        [self.privateTextAttributes setObject:textColor forKey:NSForegroundColorAttributeName];
    }
    else {
        [self.privateTextAttributes removeObjectForKey:NSForegroundColorAttributeName];
    }
}

- (NSLineBreakMode) lineBreakMode {
    return self.privateParagraphStyle.lineBreakMode;
}

- (void) setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    self.privateParagraphStyle.lineBreakMode = lineBreakMode;
}

- (instancetype) initWithEdgeInsets:(UIEdgeInsets)edgeInsets font:(UIFont *) font textColor:(UIColor *)textColor {
    self = [super init];
    if (self) {
        self.font = font;
        self.textColor = textColor;
        self.edgeInsets = edgeInsets;
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.font = [UIFont systemFontOfSize:kDefaultBodyFont];
    }
    return self;
}

@end













