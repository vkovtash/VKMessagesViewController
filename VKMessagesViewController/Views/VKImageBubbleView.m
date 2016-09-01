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

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (CGSize)sizeConstrainedToWidth:(CGFloat)width {
    if (!CGSizeEqualToSize(self.placeholderSize, CGSizeZero)) {
        return [[self class] sizeWithImageSize:CGSizeMake(self.placeholderSize.width, self.placeholderSize.height)
                                    Properties:self.properties
                            constrainedToWidth:width];
    }
    else if (self.messageBody.image) {
        return [[self class] sizeWithImage:self.messageBody.image Properties:self.properties constrainedToWidth:width];
    }
    else {
        return CGSizeZero;
    }
}

+ (CGSize)sizeWithImageSize:(CGSize)imageSize Properties:(VKImageBubbleViewProperties *)properties constrainedToWidth:(CGFloat)width {
    CGFloat horizontalInsets = properties.edgeInsets.left + properties.edgeInsets.right;
    CGFloat verticalInsets = properties.edgeInsets.top + properties.edgeInsets.bottom;
    CGFloat screenScale = [UIScreen mainScreen].scale;
    
    if (imageSize.height == 0 || imageSize.width == 0) {
        return CGSizeMake(horizontalInsets, verticalInsets);
    }
    
    CGSize resultSize = CGSizeMake(imageSize.width / screenScale, imageSize.height / screenScale);
    CGFloat ratio = imageSize.height / imageSize.width;
    resultSize.width += horizontalInsets;
    resultSize.height += verticalInsets;
    
    if (resultSize.width > properties.maxSize) {
        resultSize.width = properties.maxSize;
        resultSize.height = (resultSize.width - horizontalInsets)*ratio + verticalInsets;
    }
    
    if (resultSize.height > properties.maxSize) {
        resultSize.height = properties.maxSize;
        resultSize.width = (resultSize.height - verticalInsets)/ratio + horizontalInsets;
    }
    
    return resultSize;
}

+ (CGSize)sizeWithImage:(UIImage *)image Properties:(VKImageBubbleViewProperties *)properties constrainedToWidth:(CGFloat)width {
    if (!image) {
        return [[self class] sizeWithImageSize:CGSizeZero Properties:properties constrainedToWidth:width];
    }
    else {
        return [[self class] sizeWithImageSize:CGSizeMake(image.size.width * image.scale, image.size.height * image.scale)
                                    Properties:properties
                            constrainedToWidth:width];
    }
}

@end
