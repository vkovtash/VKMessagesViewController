//
//  VKTextBubbleView.h
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 24/12/13.
//  Copyright (c) 2013 kovtash.com. All rights reserved.
//

#import "VKBubbleView.h"
#import "VKTextBubbleViewProperties.h"

@interface VKTextBubbleView : VKBubbleView
@property (strong, nonatomic) UILabel *textBody;
@property (nonatomic,strong) VKTextBubbleViewProperties *properties;

- (id) initWithProperties:(VKTextBubbleViewProperties *) properties;
@end
