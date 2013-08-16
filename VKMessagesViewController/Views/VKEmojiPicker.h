//
//  UDEmojiPicker.h
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    VKEmojiPickerStyleVertical,
    VKEmojiPickerStyleHorizontal
} VKEmojiPickerStyle;

@class VKEmojiPicker;

@protocol VKEmojiPickerDelegate <NSObject>
@optional
- (void) emojiPicker:(VKEmojiPicker *) picker SymbolPicked:(NSString *) emojiSimbol;
- (void) emojiPickerDelButtonPressed:(VKEmojiPicker *) picker;
@end

@interface VKEmojiPicker : UIView <UIScrollViewDelegate>
@property (strong,nonatomic) NSArray *emojiList;
@property (readonly,nonatomic) UIButton *delButton;
@property (readonly,nonatomic) UIScrollView *scrollView;
@property (readonly,nonatomic) UIPageControl *pageControl;
@property (readwrite,nonatomic) UIImage *backgroundImage;
@property (weak,nonatomic) id <VKEmojiPickerDelegate> delegate;
@property (nonatomic) VKEmojiPickerStyle style;

- (void) setEdgeInsets:(UIEdgeInsets) insets ForStyle:(VKEmojiPickerStyle) style;
@end
