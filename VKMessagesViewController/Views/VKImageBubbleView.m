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

- (UIImageView *) messageBody {
    if (!_messageBody) {
        _messageBody = [[UIImageView alloc] init];
    }
    return _messageBody;
}

- (CGFloat) widthConstrainedToWidth:(CGFloat) width {
    if (self.messageBody.image) {
        return [[self class] sizeWithImage:self.messageBody.image
                                Properties:self.properties
                        constrainedToWidth:width].width;
    }
    else {
        return [[self class] sizeWithImageSize:self.placeholderSize
                                Properties:self.properties
                        constrainedToWidth:width].width;
    }
}

+ (CGSize) sizeWithImageSize:(CGSize) imageSize
              Properties:(VKImageBubbleViewProperties *) properties
      constrainedToWidth:(CGFloat) width {
    CGFloat maxWidth = width > properties.maxSize ? properties.maxSize : width;
    CGFloat horizontalInsets = properties.edgeInsets.left + properties.edgeInsets.right;
    CGFloat verticalInsets = properties.edgeInsets.top + properties.edgeInsets.bottom;
    
    if (imageSize.height == 0 || imageSize.width == 0) {
        return CGSizeMake(horizontalInsets, verticalInsets);
    }
    
    CGSize resultSize = imageSize;
    CGFloat ratio = imageSize.height / imageSize.width;
    resultSize.width += horizontalInsets;
    resultSize.height += verticalInsets;
    
    if (resultSize.width > maxWidth) {
        resultSize.width = maxWidth;
        resultSize.height = (resultSize.width - horizontalInsets)*ratio + verticalInsets;
    }
    
    if (resultSize.height > properties.maxSize) {
        resultSize.height = properties.maxSize;
        resultSize.width = (resultSize.height - verticalInsets)/ratio + horizontalInsets;
    }
    
    return resultSize;
}

+ (CGSize) sizeWithImage:(UIImage *) image
              Properties:(VKImageBubbleViewProperties *) properties
       constrainedToWidth:(CGFloat) width {
    if (!image) {
        return [[self class] sizeWithImageSize:CGSizeZero Properties:properties constrainedToWidth:width];
    }
    else {
        return [[self class] sizeWithImageSize:image.size Properties:properties constrainedToWidth:width];
    }
}

@end
