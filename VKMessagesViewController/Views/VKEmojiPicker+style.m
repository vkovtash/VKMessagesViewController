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
    emojiPicker.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    
    UIImage *keyboard = [UIImage imageNamed:@"vk_keyboard_back"];
    
    keyboard = [keyboard resizableImageWithCapInsets:UIEdgeInsetsMake(keyboard.size.height,
                                                                      0,
                                                                      0,
                                                                      0)];
    
    UIImage *keyboardOverlay = [UIImage imageNamed:@"vk_keyboard_overlay"];
    keyboardOverlay = [keyboardOverlay resizableImageWithCapInsets:UIEdgeInsetsMake(keyboardOverlay.size.height,
                                                                                    0,
                                                                                    0,
                                                                                    0)];
    UIImageView *keyboardOverlayView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                     0,
                                                                                     emojiPicker.frame.size.width,
                                                                                     keyboardOverlay.size.height)];
    keyboardOverlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    keyboardOverlayView.image = keyboardOverlay;
    [emojiPicker addSubview:keyboardOverlayView];
    
    emojiPicker.backgroundImage = keyboard;
    emojiPicker.backgroundColor = [UIColor darkGrayColor];
    
    [emojiPicker.delButton setImage:[UIImage imageNamed:@"vk_backspace_button"]
                           forState:UIControlStateNormal];
    [emojiPicker.delButton setImage:[UIImage imageNamed:@"vk_backspace_button_pressed"]
                           forState:UIControlStateHighlighted];
    
    [emojiPicker setEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, 0)
                      ForStyle:VKEmojiPickerStyleHorizontal];
    
    [emojiPicker setEdgeInsets:UIEdgeInsetsMake(2, 0, 0, -8)
                      ForStyle:VKEmojiPickerStyleVertical];
    
    if ([emojiPicker.pageControl respondsToSelector:@selector(setPageIndicatorTintColor:)]) {
        emojiPicker.pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"vk_pagecontrol_empty"]];
    }
    
    if ([emojiPicker.pageControl respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)]) {
        emojiPicker.pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"vk_pagecontrol_selected"]];
    }
    
    return emojiPicker;
}
@end
