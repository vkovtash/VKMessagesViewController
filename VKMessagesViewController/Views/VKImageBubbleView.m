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
        _messageBody.backgroundColor = [UIColor redColor];
    }
    return _messageBody;
}

- (CGFloat) widthConstrainedToWidth:(CGFloat) width {
    return [[self class] sizeWithImage:self.messageBody.image
                            Properties:self.properties
                    constrainedToWidth:width].width;
}

+ (CGSize) sizeWithImage:(UIImage *) image
              Properties:(VKBubbleViewProperties *) properties
       constrainedToWidth:(CGFloat) width {
    
    if (!image || image.size.height == 0) {
        return CGSizeZero;
    }
    
    CGSize resultSize = image.size;
    CGFloat ratio = image.size.height / image.size.width;
    resultSize.width += (properties.edgeInsets.left + properties.edgeInsets.right);
    resultSize.height += (properties.edgeInsets.top + properties.edgeInsets.bottom);
    
    if (resultSize.width > width) {
        resultSize.width = width;
        resultSize.height = width * ratio;
    }
    else if (resultSize.width < properties.minimumWidth) {
        resultSize.width = properties.minimumWidth;
        resultSize.height = width * ratio;
    }
    
    return resultSize;
}

@end
