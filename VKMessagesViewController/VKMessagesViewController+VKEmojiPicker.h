//
//  VKMessagesViewController+VKEmojiPicker.h
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 16/12/13.
//  Copyright (c) 2013 kovtash.com. All rights reserved.
//

#import "VKMessagesViewController.h"
#import "VKEmojiPicker.h"

@interface VKMessagesViewController (VKEmojiPicker) <VKEmojiPickerDelegate>
- (VKEmojiPicker *) newEmojiPicker;
@end
