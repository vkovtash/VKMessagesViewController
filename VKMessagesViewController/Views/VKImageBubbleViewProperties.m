//
//  VKImageBubbleViewProperties.m
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 16/01/14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKImageBubbleViewProperties.h"

static CGFloat kVKImageBubbleMaxSize = 230;

@implementation VKImageBubbleViewProperties

- (instancetype)initWithEdgeInsets:(UIEdgeInsets)edgeInsets maxSize:(CGFloat)maxSize {
    self = [super initWithEdgeInsets:edgeInsets];
    if (self) {
        _maxSize = maxSize;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _maxSize = kVKImageBubbleMaxSize;
    }
    return self;
}

- (CGSize)sizeWithImageSize:(CGSize)imageSize constrainedToWidth:(CGFloat)width {
    UIEdgeInsets insets = self.edgeInsets;

    CGFloat horizontalInsets = insets.left + insets.right;
    CGFloat verticalInsets = insets.top + insets.bottom;
    CGFloat scale = UIScreen.mainScreen.scale;

    if (imageSize.height == 0 || imageSize.width == 0) {
        return CGSizeMake(horizontalInsets, verticalInsets);
    }

    CGSize resultSize = CGSizeMake(imageSize.width / scale, imageSize.height / scale);
    CGFloat ratio = imageSize.height / imageSize.width;
    resultSize.width += horizontalInsets;
    resultSize.height += verticalInsets;

    if (resultSize.width > self.maxSize) {
        resultSize.width = self.maxSize;
        resultSize.height = (resultSize.width - horizontalInsets)*ratio + verticalInsets;
    }

    if (resultSize.height > self.maxSize) {
        resultSize.height = self.maxSize;
        resultSize.width = (resultSize.height - verticalInsets)/ratio + horizontalInsets;
    }

    return resultSize;
}

- (CGSize)sizeWithImage:(UIImage *)image constrainedToWidth:(CGFloat)width {
    if (image) {
        CGFloat scale = image.scale;
        return [self sizeWithImageSize:CGSizeMake(image.size.width * scale, image.size.height * scale)
                    constrainedToWidth:width];
    }

    return [self sizeWithImageSize:CGSizeZero constrainedToWidth:width];
}

@end
