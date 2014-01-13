//
//  VKTextBubbleViewProperties.h
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 26/12/13.
//  Copyright (c) 2013 kovtash.com. All rights reserved.
//

#import "VKBubbleViewProperties.h"

@interface VKTextBubbleViewProperties : VKBubbleViewProperties
@property (strong, nonatomic) UIFont *bodyFont;
@property (nonatomic) NSLineBreakMode lineBreakMode;

- (CGSize) estimatedSizeForText:(NSString *) text Widht:(CGFloat) width;
- (CGFloat) estimatedWidthForText:(NSString *) text Width:(CGFloat) width;

- (id) initWithHeaderFont:(UIFont *) headerFont BodyFont:(UIFont *) bodyFont EdgeInsets:(UIEdgeInsets) edgeInsets;
@end
