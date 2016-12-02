//
//  VKImageBubbleView.m
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 15/01/14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKImageBubbleView.h"

@implementation VKImageBubbleView
@synthesize messageBody = _messageBody;
@dynamic properties;

- (UIImageView *)messageBody {
    if (!_messageBody) {
        _messageBody = [[UIImageView alloc] init];
    }
    return _messageBody;
}

- (CGSize)sizeConstrainedToWidth:(CGFloat)width {
    if (!self.properties) {
        return CGSizeZero;
    }

    if (!CGSizeEqualToSize(self.placeholderSize, CGSizeZero)) {
        [self.properties sizeWithImageSize:CGSizeMake(self.placeholderSize.width, self.placeholderSize.height) constrainedToWidth:width];
    }
    else if (self.messageBody.image) {
        [self.properties sizeWithImage:self.messageBody.image constrainedToWidth:width];
    }

    return [self.properties sizeWithImageSize:CGSizeZero constrainedToWidth:width];
}

+ (CGSize)sizeWithImageSize:(CGSize)imageSize Properties:(VKImageBubbleViewProperties *)properties constrainedToWidth:(CGFloat)width {
    return [properties sizeWithImageSize:imageSize constrainedToWidth:width];
}

@end
