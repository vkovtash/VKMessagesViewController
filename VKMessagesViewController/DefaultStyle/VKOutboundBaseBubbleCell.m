//
//  VKOutboundBaseBubbleCell.m
//  VKMessagesViewController
//
//  Created by kovtash on 04.02.14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKOutboundBaseBubbleCell.h"
#import "VKiOSVersionCheck.h"

@implementation VKOutboundBaseBubbleCell

+ (UIImage *) backgroudImage{
    static UIImage *backgroudImage = nil;
    if (!backgroudImage) {
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
        backgroudImage = image;
    }
    return backgroudImage;
}

+ (UIImage *) selectedBackgroudImage{
    static UIImage *selectedBackgroudImage = nil;
    if (!selectedBackgroudImage) {
        UIImage *image = nil;
        if (SYSTEM_VERSION_LESS_THAN(@"7")) {
            image = [UIImage imageNamed:@"vk_message_bubble_outgouing_selected"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height * (2.0/3.0)),
                                                                        floorf(image.size.width * (1.0/3.0)),
                                                                        floorf(image.size.height * (1.0/3.0)),
                                                                        floorf(image.size.width * (2.0/3.0)))];
        }
        else {
            image = [UIImage imageNamed:@"vk_message_bubble_outgouing_selected_ios7"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height / 2),
                                                                        floorf(image.size.width * 0.44),
                                                                        floorf(image.size.height / 2),
                                                                        floorf(image.size.width * 0.56))];
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
        [self setBubbleAlign:VKBubbleAlignRight];
        self.messageDetails.textAlignment = NSTextAlignmentRight;
        self.bubbleView.normalBackgroundImage = [[self class] backgroudImage];
        self.bubbleView.selectedBackgroundImage = [[self class] selectedBackgroudImage];
    }
    return self;
}


@end
