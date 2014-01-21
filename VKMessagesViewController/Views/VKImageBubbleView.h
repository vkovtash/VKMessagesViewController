//
//  VKImageBubbleView.h
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 15/01/14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKBubbleView.h"
#import "VKImageBubbleViewProperties.h"

@interface VKImageBubbleView : VKBubbleView
@property (strong, nonatomic) UIImageView *messageBody;
@property (strong, nonatomic) VKImageBubbleViewProperties *properties;
@property (nonatomic) CGSize placeholderSize;

+ (CGSize) sizeWithImageSize:(CGSize) imageSize
              Properties:(VKImageBubbleViewProperties *) properties
      constrainedToWidth:(CGFloat) width;
@end
