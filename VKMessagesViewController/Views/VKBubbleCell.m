//
//  VKBubbleCell.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKBubbleCell.h"

@interface VKBubbleCell()
@property (nonatomic,strong) UIImage *normalBackgroundImgage;
@property (nonatomic,strong) UIImage *selectedBackgroundImgage;
@end

@implementation VKBubbleCell

#pragma mark - Publick properties

- (NSString *) messageLeftHeader{
    return self.bubbleView.messageLeftHeader.text;
}

- (void) setMessageLeftHeader:(NSString *)messageLeftHeader{
    self.bubbleView.messageLeftHeader.text = messageLeftHeader;
}

- (NSString *) messageRightHeader {
    return self.bubbleView.messageRightHeader.text;
}

- (void) setMessageRightHeader:(NSString *)messageRightHeader {
    self.bubbleView.messageRightHeader.text = messageRightHeader;
}

- (void) setBubbleAlign:(VKBubbleAlign)bubbleAlign{
    _bubbleAlign = bubbleAlign;
    [self applyLayout];
}

#pragma mark - Publick methods

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [self.bubbleView setSelected:selected];
}

#pragma mark - Class methods

+ (CGFloat) bubbleViewWidthMultiplier{
    return 0.9;
}

+ (UIEdgeInsets) edgeInsets{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma - mark Init

- (void) postInit{
    [self.contentView addSubview:self.bubbleView];
    self.autoresizesSubviews = YES;
}

- (void) setFrame:(CGRect)frame{
    BOOL layoutNeeded = !CGSizeEqualToSize(self.frame.size, frame.size);
    [super setFrame:frame];
    if (layoutNeeded) {
        [self applyLayout];
    }
}

- (void) applyLayout{
    UIEdgeInsets insets = [[self class] edgeInsets];
    CGFloat estimatedWidth = [self.bubbleView widthConstrainedToWidth: self.contentView.frame.size.width * [[self class] bubbleViewWidthMultiplier] - insets.right - insets.left];
    
    switch (self.bubbleAlign) {
        case VKBubbleAlignRight:
            self.bubbleView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
            self.bubbleView.frame = CGRectMake(self.contentView.frame.size.width - estimatedWidth - insets.right,
                                               insets.top,
                                               estimatedWidth,
                                               self.contentView.frame.size.height - insets.top - insets.bottom);
            break;
        
        case VKBubbleAlignLeft:
        default:
            self.bubbleView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
            self.bubbleView.frame = CGRectMake(insets.left,
                                               insets.top,
                                               estimatedWidth,
                                               self.contentView.frame.size.height - insets.top - insets.bottom);
            break;
    }
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self postInit];
    }
    return self;
}

- (id)  init{
    self = [super init];
    if (self) {
        [self postInit];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self postInit];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self postInit];
    }
    return self;
}

- (id)initWithBubbleView:(VKBubbleView *)bubbleView reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bubbleView = bubbleView;
        [self postInit];
    }
    return self;
}

@end

























