//
//  VKTextBubbleViewProperties.m
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 26/12/13.
//  Copyright (c) 2013 kovtash.com. All rights reserved.
//

#import "VKTextBubbleViewProperties.h"
#import "TTTAttributedLabel.h"

static const CGFloat kViewMaxHeight = 9999;

@interface VKTextBubbleViewProperties()
@property (strong,nonatomic) TTTAttributedLabel *etalonLabel;
@end

@implementation VKTextBubbleViewProperties

- (id) initWithHeaderFont:(UIFont *) headerFont BodyFont:(UIFont *) bodyFont EdgeInsets:(UIEdgeInsets) edgeInsets {
    self = [super init];
    if (self) {
        self.headerFont = headerFont;
        self.bodyFont = bodyFont;
        self.edgeInsets = edgeInsets;
    }
    return self;
}

- (TTTAttributedLabel *) etalonLabel{
    if (!_etalonLabel) {
        _etalonLabel = [[TTTAttributedLabel alloc] init];
        _etalonLabel.numberOfLines = 0;
    }
    return _etalonLabel;
}

- (void) setBodyFont:(UIFont *)bodyFont{
    _bodyFont = bodyFont;
    self.etalonLabel.font = _bodyFont;
}

- (void) setLineBreakMode:(NSLineBreakMode)lineBreakMode{
    _lineBreakMode = lineBreakMode;
    self.etalonLabel.lineBreakMode = _lineBreakMode;
}

- (CGSize) estimatedSizeForText:(NSString *) text Widht:(CGFloat) width{
    self.etalonLabel.frame = CGRectMake(0, 0, width - self.edgeInsets.left - self.edgeInsets.right, kViewMaxHeight);
    self.etalonLabel.text = text;
    [self.etalonLabel sizeToFit];
    CGSize bodySize = self.etalonLabel.frame.size;
    bodySize.width += (self.edgeInsets.left + self.edgeInsets.right);
    bodySize.height += (self.estimatedHeaderHeigth + self.edgeInsets.top + self.edgeInsets.bottom);
    if (bodySize.width < self.minimumWidth) {
        bodySize.width = self.minimumWidth;
    }
    return bodySize;
}

- (CGFloat) estimatedWidthForText:(NSString *) text Width:(CGFloat) width{
    CGFloat resultWidth = [text sizeWithFont:self.bodyFont
                           constrainedToSize:CGSizeMake(kViewMaxHeight, kViewMaxHeight)
                               lineBreakMode:self.lineBreakMode].width;
    resultWidth += (self.edgeInsets.left + self.edgeInsets.right);
    resultWidth = ceilf(resultWidth);
    if (resultWidth < self.minimumWidth) {
        resultWidth = self.minimumWidth;
    }
    else if (resultWidth > width){
        resultWidth = width;
    }
    return resultWidth;
}

+ (id) defaultProperties {
    id properties = [super defaultProperties];
    [properties setBodyFont:[UIFont systemFontOfSize:14]];
    return properties;
}

@end













