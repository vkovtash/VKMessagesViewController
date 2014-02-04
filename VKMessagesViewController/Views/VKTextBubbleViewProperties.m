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

- (UIFont *) bodyFont {
    return [self.privateTextAttributes objectForKey:NSFontAttributeName];
}

- (void) setBodyFont:(UIFont *)bodyFont {
    if (bodyFont) {
        [self.privateTextAttributes setObject:bodyFont forKey:NSFontAttributeName];
    }
    else {
        [self.privateTextAttributes removeObjectForKey:NSFontAttributeName];
    }
}

- (NSLineBreakMode) lineBreakMode {
    return self.privateParagraphStyle.lineBreakMode;
}

- (void) setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    self.privateParagraphStyle.lineBreakMode = lineBreakMode;
}

- (instancetype) initWithEdgeInsets:(UIEdgeInsets)edgeInsets bodyFont:(UIFont *) bodyFont {
    self = [super init];
    if (self) {
        self.bodyFont = bodyFont;
        self.edgeInsets = edgeInsets;
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.bodyFont = [UIFont systemFontOfSize:kDefaultBodyFont];
    }
    return self;
}

@end













