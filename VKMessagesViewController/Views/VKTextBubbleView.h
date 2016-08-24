//
//  VKTextBubbleView.h
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 24/12/13.
//  Copyright (c) 2013 kovtash.com. All rights reserved.
//

#import "VKBubbleView.h"
#import "VKTextBubbleViewProperties.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>

@interface VKBubbleMention: NSObject
@property (readonly, nonatomic) NSRange range;
@property (readonly, nonatomic) NSURL *url;

- (instancetype)initWithRange:(NSRange)range url:(NSURL *)url;
+ (instancetype)withRange:(NSRange)range url:(NSURL *)url;
@end


@interface VKTextBubbleView : VKBubbleView
@property (readonly, nonatomic) TTTAttributedLabel *messageBody;
@property (nonatomic,strong) VKTextBubbleViewProperties *properties;
@property (readwrite, nonatomic) NSString *text;
@property (readwrite, nonatomic) NSAttributedString *attributedText;
@property (strong, nonatomic) NSArray<NSString *> *highligts; //Regexp strings
@property (readonly, nonatomic) NSArray<VKBubbleMention *> *mentions;

- (instancetype)initWithBubbleProperties:(VKTextBubbleViewProperties *)properties;

- (void)addMention:(VKBubbleMention *)mention;
- (void)addMentionWithURL:(NSURL *)url range:(NSRange)range;

+ (CGSize)sizeWithText:(NSString *)text
            Properties:(VKTextBubbleViewProperties *)properties
    constrainedToWidth:(CGFloat)width;

+ (CGSize)sizeWithAttributedString:(NSAttributedString *)attributedString
                        Properties:(VKTextBubbleViewProperties *)properties
                constrainedToWidth:(CGFloat) width;
@end
