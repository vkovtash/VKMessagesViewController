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
    //used for propetly layout bubble views
    [super setFrame:CGRectMake(self.frame.origin.x,
                               self.frame.origin.y,
                               self.frame.size.width,
                               500)];
    self.contentView.frame = self.bounds;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.bubbleViewMaxWidth = kDefaultBubbleViewWidth;
    [self.contentView addSubview:self.bubbleView];
    self.autoresizesSubviews = YES;
}

- (void) layoutSubviews {
    [UIView performWithoutAnimation:^{
        [super layoutSubviews];
        [self applyLayout];
    }];
}

- (void) applyLayout{
    UIEdgeInsets insets = self.edgeInsets;
    CGSize estimatedSize = [self.bubbleView sizeConstrainedToWidth:self.bubbleViewMaxWidth];
    
    switch (self.bubbleAlign) {
        case VKBubbleAlignRight:
            self.bubbleView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin;
            self.bubbleView.frame = CGRectMake(self.contentView.bounds.size.width - estimatedSize.width - insets.right,
                                               insets.top,
                                               estimatedSize.width,
                                               estimatedSize.height);
            break;
            
        case VKBubbleAlignLeft:
        default:
            self.bubbleView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin;
            self.bubbleView.frame = CGRectMake(insets.left,
                                               insets.top,
                                               estimatedSize.width,
                                               estimatedSize.height);
            break;
    }
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

























