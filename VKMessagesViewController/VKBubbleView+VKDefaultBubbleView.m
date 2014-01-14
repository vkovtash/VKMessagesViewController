//
//  VKBubbleView+VKDefaultBubbleView.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 13/01/14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKBubbleView+VKDefaultBubbleView.h"
#import "VKiOSVersionCheck.h"

@implementation VKBubbleView (VKDefaultBubbleView)

+ (UIImage *) inboundBackgroudImage{
    static UIImage *inboundBackgroudImage = nil;
    if (!inboundBackgroudImage) {
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
        inboundBackgroudImage = image;
    }
    return inboundBackgroudImage;
}

+ (UIImage *) outboundBackgroudImage{
    static UIImage *outboundBackgroudImage = nil;
    if (!outboundBackgroudImage) {
        UIImage *image = nil;
        if (SYSTEM_VERSION_LESS_THAN(@"7")) {
            image = [UIImage imageNamed:@"vk_message_bubble_outgouing"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height * (2.0/3.0)),
                                                                        floorf(image.size.width * (1.0/3.0)),
                                                                        floorf(image.size.height * (1.0/3.0)),
                                                                        floorf(image.size.width * (2.0/3.0)))];
        }
        else {
            image = [UIImage imageNamed:@"vk_message_bubble_outgouing_ios7"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height / 2),
                                                                        floorf(image.size.width * 0.44),
                                                                        floorf(image.size.height / 2),
                                                                        floorf(image.size.width * 0.56))];
        }
        outboundBackgroudImage = image;
    }
    return outboundBackgroudImage;
}

+ (UIImage *) inboundSelectedBackgroudImage{
    static UIImage *inboundSelectedBackgroudImage = nil;
    if (!inboundSelectedBackgroudImage) {
        UIImage *image = [UIImage imageNamed:@"vk_message_bubble_incoming_selected"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height * (2.0/3.0)),
                                                                    floorf(image.size.width * (2.0/3.0)),
                                                                    floorf(image.size.height * (1.0/3.0)),
                                                                    floorf(image.size.width * (1.0/3.0)))];
        inboundSelectedBackgroudImage = image;
    }
    return inboundSelectedBackgroudImage;
}

+ (UIImage *) outboundSelectedBackgroudImage{
    static UIImage *outboundSelectedBackgroudImage = nil;
    if (!outboundSelectedBackgroudImage) {
        UIImage *image = [UIImage imageNamed:@"vk_message_bubble_outgouing_selected"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height * (2.0/3.0)),
                                                                    floorf(image.size.width * (1.0/3.0)),
                                                                    floorf(image.size.height * (1.0/3.0)),
                                                                    floorf(image.size.width * (2.0/3.0)))];
        outboundSelectedBackgroudImage = image;
    }
    return outboundSelectedBackgroudImage;
}

+ (instancetype) inboundBubbleWithProperties:(VKBubbleViewProperties *) properties {
    VKBubbleView *bubbleView = [[[self class] alloc] initWithBubbleProperties:properties];
    bubbleView.normalBackgroundImage = [[self class] inboundBackgroudImage];
    bubbleView.selectedBackgroundImage = [[self class] inboundSelectedBackgroudImage];
    return bubbleView;
}

+ (instancetype) outboundBubbleWithProperties:(VKBubbleViewProperties *) properties {
    VKBubbleView *bubbleView = [[[self class] alloc] initWithBubbleProperties:properties];
    bubbleView.normalBackgroundImage = [[self class] outboundBackgroudImage];
    bubbleView.selectedBackgroundImage = [[self class] outboundSelectedBackgroudImage];
    return bubbleView;
}

@end

























