//
//  VKEmojiPicker+style.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKEmojiPicker+style.h"

@implementation VKEmojiPicker (style)
+ (id) emojiPicker{
    VKEmojiPicker *emojiPicker = [[[self class] alloc] init];
    emojiPicker.backgroundColor = [UIColor colorWithRed:0.8 green:0.81 blue:0.83 alpha:0.7];
    [emojiPicker.delButton setImage:[UIImage imageNamed:@"vk_backspace_button"]
                           forState:UIControlStateNormal];
    [emojiPicker.delButton setImage:[UIImage imageNamed:@"vk_backspace_button_pressed"]
                           forState:UIControlStateHighlighted];
    return emojiPicker;
}
@end
