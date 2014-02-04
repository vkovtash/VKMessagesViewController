//
//  VKBaseBubbleCell.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 13/01/14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKDefaultBubbleCell.h"
#import "VKiOSVersionCheck.h"

static CGFloat bubbleViewWidthMultiplier = 0.9;
static CGFloat kMessageDetailsFontSize = 12;

@interface VKDefaultBubbleCell()
@end

@implementation VKDefaultBubbleCell
@synthesize messageDetails = _messageDetails;

- (instancetype) initWithBubbleView:(VKBubbleView *)bubbleView reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithBubbleView:bubbleView reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.messageDetails];
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat detailOffset = 0;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
            detailOffset = 6;
            self.messageDetails.textColor = [UIColor darkGrayColor];
        }
        else {
            detailOffset = 4;
            self.messageDetails.shadowOffset = CGSizeMake(0, -1);
            self.messageDetails.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            self.messageDetails.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
        }
        
        UIEdgeInsets cellEdgeInsets = [[self class] edgeInsets];
        self.messageDetails.frame = CGRectMake(cellEdgeInsets.left + detailOffset,
                                               self.contentView.bounds.size.height - 18,
                                               self.contentView.bounds.size.width - cellEdgeInsets.right - cellEdgeInsets.left - detailOffset*2,
                                               18);
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
    return self.contentView.bounds.size.width * bubbleViewWidthMultiplier;
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
        }
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
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

#pragma mark - Class methods

+ (CGFloat) bubbleViewWidthConstraintForCellWidth:(CGFloat) cellWidth {
    UIEdgeInsets insets = [[self class] edgeInsets];
    return cellWidth*bubbleViewWidthMultiplier - insets.right - insets.left;
}

+ (UIEdgeInsets) edgeInsets{
    return UIEdgeInsetsMake(5, 5, 16, 5);
}

@end












