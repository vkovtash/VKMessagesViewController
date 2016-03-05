//
//  VKDefaultInboundBubbleCell.m
//  VKMessagesViewController
//
//  Created by kovtash on 04.02.14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKInboundBaseBubbleCell.h"

static NSString *const kBackgoundImageName = @"vk_message_bubble_incoming";
static NSString *const kBackgoundSelectedImageName = @"vk_message_bubble_incoming_selected";

@implementation VKInboundBaseBubbleCell

+ (UIImage *)backgroudImage {
    static UIImage *backgroudImage = nil;
    if (!backgroudImage) {
        backgroudImage = [UIImage imageNamed:kBackgoundImageName];
        backgroudImage = [backgroudImage resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(backgroudImage.size.height / 2),
                                                                                      floorf(backgroudImage.size.width * 0.56),
                                                                                      floorf(backgroudImage.size.height / 2),
                                                                                      floorf(backgroudImage.size.width * 0.44))];
    }
    return backgroudImage;
}

+ (UIImage *)selectedBackgroudImage {
    static UIImage *selectedBackgroudImage = nil;
    if (!selectedBackgroudImage) {
        selectedBackgroudImage = [UIImage imageNamed:kBackgoundSelectedImageName];
        selectedBackgroudImage = [selectedBackgroudImage resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(selectedBackgroudImage.size.height / 2),
                                                                                                      floorf(selectedBackgroudImage.size.width * 0.56),
                                                                                                      floorf(selectedBackgroudImage.size.height / 2),
                                                                                                      floorf(selectedBackgroudImage.size.width * 0.44))];
    }
    return selectedBackgroudImage;
}

+ (VKBubbleView *)newBubbleView {
    return [[VKBubbleView alloc] initWithBubbleProperties:[[self class] newBubbleViewProperties]];
}

+ (VKBubbleViewProperties *)newBubbleViewProperties {
    return [[VKBubbleViewProperties alloc] init];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithBubbleView:[[self class] newBubbleView]
                     reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBubbleAlign:VKBubbleAlignLeft];
        self.messageDetails.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

@end
