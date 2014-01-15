//
//  VKImageBubbleView.h
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 15/01/14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKBubbleView.h"

@interface VKImageBubbleView : VKBubbleView
@property (strong, nonatomic) UIImageView *messageBody;

+ (CGSize) sizeWithImage:(UIImage *) image
              Properties:(VKBubbleViewProperties *) properties
       constrainedToWidth:(CGFloat) width;
@end
