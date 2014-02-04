//
//  VKDefaultInboundBubbleCell.m
//  VKMessagesViewController
//
//  Created by kovtash on 04.02.14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKInboundBaseBubbleCell.h"
#import "VKiOSVersionCheck.h"

@implementation VKInboundBaseBubbleCell

+ (UIImage *) backgroudImage{
    static UIImage *backgroudImage = nil;
    if (!backgroudImage) {
        UIImage *image = nil;
        if (SYSTEM_VERSION_LESS_THAN(@"7")) {
            image = [UIImage imageNamed:@"vk_message_bubble_incoming"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height * (2.0/3.0)),
                                                                        floorf(image.size.width * (2.0/3.0)),
                                                                        floorf(image.size.height * (1.0/3.0)),
                                                                        floorf(image.size.width * (1.0/3.0)))];
        }
        else{
            image = [UIImage imageNamed:@"vk_message_bubble_incoming_ios7"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height / 2),
                                                                        floorf(image.size.width * 0.56),
                                                                        floorf(image.size.height / 2),
                                                                        floorf(image.size.width * 0.44))];
        }
        backgroudImage = image;
    }
    return backgroudImage;
}

+ (UIImage *) selectedBackgroudImage{
    static UIImage *selectedBackgroudImage = nil;
    if (!selectedBackgroudImage) {
        UIImage *image = nil;
        if (SYSTEM_VERSION_LESS_THAN(@"7")) {
            image = [UIImage imageNamed:@"vk_message_bubble_incoming_selected"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height * (2.0/3.0)),
                                                                        floorf(image.size.width * (2.0/3.0)),
                                                                        floorf(image.size.height * (1.0/3.0)),
                                                                        floorf(image.size.width * (1.0/3.0)))];
        }
        else {
            image = [UIImage imageNamed:@"vk_message_bubble_incoming_selected_ios7"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height / 2),
                                                                        floorf(image.size.width * 0.56),
                                                                        floorf(image.size.height / 2),
                                                                        floorf(image.size.width * 0.44))];
        }
        selectedBackgroudImage = image;
    }
    return selectedBackgroudImage;
}

+ (VKBubbleView *) newBubbleView {
    return [[VKBubbleView alloc] initWithBubbleProperties:[[self class] newBubbleViewProperties]];
}

+ (VKBubbleViewProperties *) newBubbleViewProperties {
    return [[VKBubbleViewProperties alloc] init];
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithBubbleView:[[self class] newBubbleView]
                     reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBubbleAlign:VKBubbleAlignLeft];
        self.messageDetails.textAlignment = NSTextAlignmentLeft;
        self.bubbleView.normalBackgroundImage = [[self class] backgroudImage];
        self.bubbleView.selectedBackgroundImage = [[self class] selectedBackgroudImage];
    }
    return self;
}

@end
