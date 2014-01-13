//
//  VKBaseBubbleCell.h
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 13/01/14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKBubbleCell.h"

@interface VKBaseBubbleCell : VKBubbleCell
@property (strong, nonatomic) NSDate *messageDate;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

+ (instancetype) inboundCellWithBubbleView:(VKBubbleView *) bubbleView reuseIdentifier:(NSString *) reuseIdentifier;
+ (instancetype) outboundCellWithBubbleView:(VKBubbleView *) bubbleView reuseIdentifier:(NSString *) reuseIdentifier;
@end
