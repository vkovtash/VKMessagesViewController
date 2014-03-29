//
//  VKBaseBubbleCell.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 13/01/14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKDefaultBubbleCell.h"

static CGFloat bubbleViewInset = 50;
static CGFloat kMessageDetailsFontSize = 12;
static CGFloat kMessageDetailsFiledHeight = 20;
static CGFloat kMessageDetailsHorizontalInset = 6;

@interface VKDefaultBubbleCell()
@end

@implementation VKDefaultBubbleCell
@synthesize messageDetails = _messageDetails;

- (instancetype) initWithBubbleView:(VKBubbleView *)bubbleView reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithBubbleView:bubbleView reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.messageDetails];
        self.backgroundColor = [UIColor clearColor];
        
        self.messageDetails.textColor = [UIColor darkGrayColor];
        UIEdgeInsets cellEdgeInsets = [[self class] edgeInsets];
        self.messageDetails.frame = CGRectMake(cellEdgeInsets.left + kMessageDetailsHorizontalInset,
                                               self.contentView.bounds.size.height - kMessageDetailsFiledHeight,
                                               self.contentView.bounds.size.width - cellEdgeInsets.right - cellEdgeInsets.left - kMessageDetailsHorizontalInset*2,
                                               kMessageDetailsFiledHeight);
    }
    return self;
}

- (NSDateFormatter *) dateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDoesRelativeDateFormatting:YES];
    }
    return dateFormatter;
}

- (UILabel *) messageDetails{
    if (!_messageDetails) {
        _messageDetails = [[UILabel alloc] init];
        _messageDetails.backgroundColor = [UIColor clearColor];
        _messageDetails.textAlignment = NSTextAlignmentRight;
        _messageDetails.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        _messageDetails.font = [UIFont systemFontOfSize:kMessageDetailsFontSize];
    }
    return _messageDetails;
}

- (void) setMessageDate:(NSDate *)messageDate{
    _messageDate = messageDate;
    [self updateDetails];
}

- (void) setMessageState:(NSString *)messageState {
    _messageState = messageState;
    [self updateDetails];
}

- (UIEdgeInsets) edgeInsets {
    return [[self class] edgeInsets];
}

- (CGFloat) bubbleViewMaxWidth {
    return [[self class] bubbleViewWidthConstraintForCellWidth:self.contentView.bounds.size.width];
}

- (void) updateDetails {
    NSString *dateText = nil;
    if (self.dateFormatter && _messageDate) {
        dateText = [self.dateFormatter stringFromDate:_messageDate];
    }
    self.messageDetails.text = [NSString stringWithFormat:@"%@ %@",
                                _messageState ? _messageState : @"",
                                dateText ? dateText : @""];
    
}

- (void) setBubbleAccessoryView:(UIView *)bubbleAccessoryView {
    if (_bubbleAccessoryView != bubbleAccessoryView) {
        [_bubbleAccessoryView removeFromSuperview];
        _bubbleAccessoryView = bubbleAccessoryView;
        
        if (_bubbleAccessoryView) {
            [self.contentView addSubview:_bubbleAccessoryView];
            [self layoutBubbleAccessoryView];
        }
    }
}

- (void) setBubbleAlign:(VKBubbleAlign)bubbleAlign {
    [super setBubbleAlign:bubbleAlign];
    [self layoutBubbleAccessoryView];
}

-(void) layoutBubbleAccessoryView {
    if (_bubbleAccessoryView) {
        if (self.bubbleAlign == VKBubbleAlignLeft) {
            _bubbleAccessoryView.center = CGPointMake(self.bubbleView.frame.origin.x + self.bubbleView.frame.size.width + [[self class] edgeInsets].right + _bubbleAccessoryView.bounds.size.width/2,
                                                      (self.bubbleView.frame.origin.y + [[self class] edgeInsets].top + self.bubbleView.frame.size.height)/2);
        }
        else {
            _bubbleAccessoryView.center = CGPointMake(self.bubbleView.frame.origin.x - [[self class] edgeInsets].left - _bubbleAccessoryView.bounds.size.width/2,
                                                      (self.bubbleView.frame.origin.y + [[self class] edgeInsets].top + self.bubbleView.frame.size.height)/2);
        }
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self layoutBubbleAccessoryView];
}

#pragma mark - Class methods

+ (CGFloat) bubbleViewWidthConstraintForCellWidth:(CGFloat) cellWidth {
    UIEdgeInsets insets = [[self class] edgeInsets];
    return cellWidth - bubbleViewInset - insets.right - insets.left;
}

+ (UIEdgeInsets) edgeInsets{
    return UIEdgeInsetsMake(5, 5, kMessageDetailsFiledHeight, 5);
}

@end












