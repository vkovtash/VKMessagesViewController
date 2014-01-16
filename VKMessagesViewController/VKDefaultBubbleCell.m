//
//  VKBaseBubbleCell.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 13/01/14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKDefaultBubbleCell.h"
#import "VKiOSVersionCheck.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat bubbleViewWidthMultiplier = 0.9;
static CGFloat kMessageDetailsFontSize = 12;

@interface VKDefaultBubbleCell()
@end

@implementation VKDefaultBubbleCell

- (instancetype) initWithBubbleView:(VKBubbleView *)bubbleView reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithBubbleView:bubbleView reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.messageDetails];
        
        CGFloat detailOffset = 0;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
            detailOffset = 6;
        }
        else {
            detailOffset = 4;
        }
        
        UIEdgeInsets cellEdgeInsets = [[self class] edgeInsets];
        self.messageDetails.frame = CGRectMake(cellEdgeInsets.left + detailOffset,
                                               self.contentView.bounds.size.height - 18,
                                               self.contentView.bounds.size.width - cellEdgeInsets.right - cellEdgeInsets.left - detailOffset*2,
                                               18);
    }
    return self;
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
    if (_dateFormatter && _messageDate) {
        dateText = [self.dateFormatter stringFromDate:_messageDate];
    }
    self.messageDetails.text = [NSString stringWithFormat:@"%@ %@",
                                _messageState ? _messageState : @"",
                                dateText ? dateText : @""];
    
}

#pragma mark - Class methods

+ (CGFloat) bubbleViewWidthConstraintForCellWidth:(CGFloat) cellWidth {
    UIEdgeInsets insets = [[self class] edgeInsets];
    return cellWidth*bubbleViewWidthMultiplier - insets.right - insets.left;
}

+ (UIEdgeInsets) edgeInsets{
    return UIEdgeInsetsMake(5, 5, 16, 5);
}

+ (instancetype) cellWithBubbleView:(VKBubbleView *) bubbleView reuseIdentifier:(NSString *) reuseIdentifier {
    
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDoesRelativeDateFormatting:YES];
    }
    
    VKDefaultBubbleCell *cell = [[[self class] alloc] initWithBubbleView:bubbleView reuseIdentifier:reuseIdentifier];
    if (cell) {
        cell.backgroundColor = [UIColor clearColor];
        cell.dateFormatter = dateFormatter;
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
            cell.messageDetails.textColor = [UIColor darkGrayColor];
        }
        else {
            cell.messageDetails.shadowOffset = CGSizeMake(0, -1);
            cell.messageDetails.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            cell.messageDetails.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
        }
    }
    return cell;
}

+ (instancetype) inboundCellWithBubbleView:(VKBubbleView *) bubbleView reuseIdentifier:(NSString *) reuseIdentifier {
    VKDefaultBubbleCell *cell = [[self class] cellWithBubbleView:bubbleView reuseIdentifier:reuseIdentifier];
    [cell setBubbleAlign:VKBubbleAlignLeft];
    cell.messageDetails.textAlignment = NSTextAlignmentLeft;
    return cell;
}

+ (instancetype) outboundCellWithBubbleView:(VKBubbleView *) bubbleView reuseIdentifier:(NSString *) reuseIdentifier {
    VKDefaultBubbleCell *cell = [[self class] cellWithBubbleView:bubbleView reuseIdentifier:reuseIdentifier];
    [cell setBubbleAlign:VKBubbleAlignRight];
    cell.messageDetails.textAlignment = NSTextAlignmentRight;
    return cell;
}

@end












