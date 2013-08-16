//
//  VKBobbleViewProperties.h
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKBubbleViewProperties : NSObject
@property (strong,nonatomic) UIFont *headerFont;
@property (strong,nonatomic) UIFont *bodyFont;
@property (nonatomic) UIEdgeInsets edgeInsets;
@property (nonatomic) NSUInteger minimumWidth;
@property (nonatomic) NSLineBreakMode lineBreakMode;
- (CGFloat) estimatedHeaderHeigth;
- (CGSize) estimatedSizeForText:(NSString *) text Widht:(CGFloat) width;
- (CGFloat) estimatedWidthForText:(NSString *) text Width:(CGFloat) width;
- (id) initWithHeaderFont:(UIFont *) headerFont BodyFont:(UIFont *) bodyFont EdgeInsets:(UIEdgeInsets) edgeInsets;
+ (id) defaultProperties;
@end
