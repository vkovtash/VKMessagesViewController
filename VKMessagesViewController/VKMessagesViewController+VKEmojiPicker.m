//
//  VKMessagesViewController+VKEmojiPicker.m
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 16/12/13.
//  Copyright (c) 2013 kovtash.com. All rights reserved.
//

#import "VKMessagesViewController+VKEmojiPicker.h"
#import "VKEmojiPicker+style.h"
#import "NSString+deletingLastSymbol.h"

@implementation VKMessagesViewController (VKEmojiPicker)

- (VKEmojiPicker *) newEmojiPicker {
    VKEmojiPicker *emojiPicker = [VKEmojiPicker emojiPicker];
    emojiPicker.delegate = self;
    return emojiPicker;
}

#pragma mark - UDEmojiPickerDelegate

- (void) emojiPicker:(VKEmojiPicker *)picker SymbolPicked:(NSString *)emojiSimbol{
    self.messageToolbar.textView.text = [self.messageToolbar.textView.text stringByAppendingString:emojiSimbol];
}

- (void) emojiPickerDelButtonPressed:(VKEmojiPicker *)picker{
    self.messageToolbar.textView.text = [self.messageToolbar.textView.text stringByDeletingLastSymbol];
}

@end
