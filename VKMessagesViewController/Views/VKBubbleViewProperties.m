//
//  VKBobbleViewProperties.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKBubbleViewProperties.h"
#import "TTTAttributedLabel.h"

#define VK_MAX_HEIGHT 9999
#define MINIMUM_WIDTH 180

@interface VKBubbleViewProperties()
@property (strong,nonatomic) TTTAttributedLabel *etalonLabel;
@end

@implementation VKBubbleViewProperties
- (TTTAttributedLabel *) etalonLabel{
    if (!_etalonLabel) {
        _etalonLabel = [[TTTAttributedLabel alloc] init];
        _etalonLabel.numberOfLines = 0;
        _etalonLabel.dataDetectorTypes = UIDataDetectorTypeNone;
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

- (CGFloat) estimatedHeaderHeigth{
    NSString static *VKMessageDummyHeaderText = @"Header text";
    CGSize headerSize = [VKMessageDummyHeaderText sizeWithFont:self.headerFont
                                                      forWidth:MINIMUM_WIDTH
                                                 lineBreakMode:NSLineBreakByTruncatingTail];
    return headerSize.height;
}

- (CGSize) estimatedSizeForText:(NSString *) text Widht:(CGFloat) width{    
    self.etalonLabel.frame = CGRectMake(0, 0, width - self.edgeInsets.left - self.edgeInsets.right, VK_MAX_HEIGHT);
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
                           constrainedToSize:CGSizeMake(VK_MAX_HEIGHT,VK_MAX_HEIGHT)
                               lineBreakMode:self.lineBreakMode].width;
    resultWidth += (self.edgeInsets.left + self.edgeInsets.right);
    if (resultWidth < self.minimumWidth) {
        resultWidth = self.minimumWidth;
    }
    else if (resultWidth > width){
        resultWidth = width;
    }
    return resultWidth;
}

- (id) initWithHeaderFont:(UIFont *) headerFont BodyFont:(UIFont *) bodyFont EdgeInsets:(UIEdgeInsets) edgeInsets{
    self = [super init];
    if (self) {
        self.headerFont = headerFont;
        self.bodyFont = bodyFont;
        self.edgeInsets = edgeInsets;
    }
    return self;
}

+ (id) defaultProperties{
    id defaultProperties = [[[self class] alloc] initWithHeaderFont:[UIFont systemFontOfSize:12]
                                                           BodyFont:[UIFont systemFontOfSize:14]
                                                         EdgeInsets:UIEdgeInsetsMake(4, 12, 4, 10)];
    [defaultProperties setMinimumWidth:MINIMUM_WIDTH];
    [defaultProperties setLineBreakMode:NSLineBreakByWordWrapping];
    return defaultProperties;
}
@end
