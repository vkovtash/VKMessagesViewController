//
//  VKBobbleViewProperties.h
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKBubbleViewProperties : NSObject
@property (strong, nonatomic) UIFont *headerFont;
@property (nonatomic) UIEdgeInsets edgeInsets;
@property (nonatomic) NSUInteger minimumWidth;
- (CGFloat) estimatedHeaderHeigth;
- (id) initWithHeaderFont:(UIFont *) headerFont EdgeInsets:(UIEdgeInsets) edgeInsets;
@end
