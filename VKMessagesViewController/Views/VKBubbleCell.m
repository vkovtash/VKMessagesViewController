//
//  VKBubbleCell.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKBubbleCell.h"

static CGFloat kDefaultBubbleViewWidth = 200;

@interface VKBubbleCell()
@end

@implementation VKBubbleCell

#pragma mark - Publick properties

- (void) setBubbleAlign:(VKBubbleAlign)bubbleAlign{
    _bubbleAlign = bubbleAlign;
    [self applyLayout];
}

- (void) setBubbleViewMaxWidth:(CGFloat)bubbleViewMaxWidth {
    if (_bubbleViewMaxWidth != bubbleViewMaxWidth) {
        _bubbleViewMaxWidth = bubbleViewMaxWidth;
        [self applyLayout];
    }
}

#pragma mark - Publick methods

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [self.bubbleView setSelected:selected];
}

#pragma - mark Init

- (void) postInit{
    self.bubbleViewMaxWidth = kDefaultBubbleViewWidth;
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
    UIEdgeInsets insets = self.edgeInsets;
    CGFloat estimatedWidth = [self.bubbleView widthConstrainedToWidth:self.bubbleViewMaxWidth - insets.right - insets.left];
    
    switch (self.bubbleAlign) {
        case VKBubbleAlignRight:
            self.bubbleView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
            self.bubbleView.frame = CGRectMake(self.contentView.bounds.size.width - estimatedWidth - insets.right,
                                               insets.top,
                                               estimatedWidth,
                                               self.contentView.bounds.size.height - insets.top - insets.bottom);
            break;
        
        case VKBubbleAlignLeft:
        default:
            self.bubbleView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
            self.bubbleView.frame = CGRectMake(insets.left,
                                               insets.top,
                                               estimatedWidth,
                                               self.contentView.bounds.size.height - insets.top - insets.bottom);
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
        _bubbleView = bubbleView;
        [self postInit];
    }
    return self;
}

@end

























