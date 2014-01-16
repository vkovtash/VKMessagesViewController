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
    return [[self class] sizeWithImage:self.messageBody.image
                            Properties:self.properties
                    constrainedToWidth:width].width;
}

+ (CGSize) sizeWithImage:(UIImage *) image
              Properties:(VKImageBubbleViewProperties *) properties
       constrainedToWidth:(CGFloat) width {
    
    CGFloat maxWidth = width > properties.maxSize ? properties.maxSize : width;
    CGFloat horizontalInsets = properties.edgeInsets.left + properties.edgeInsets.right;
    CGFloat verticalInsets = properties.edgeInsets.top + properties.edgeInsets.bottom;
    
    if (!image || image.size.height == 0 || image.size.width == 0) {
        return CGSizeMake(horizontalInsets, verticalInsets);
    }
    
    CGSize resultSize = image.size;
    CGFloat ratio = image.size.height / image.size.width;
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

@end
