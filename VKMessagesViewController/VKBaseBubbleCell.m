//
//  VKBaseBubbleCell.m
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 13/01/14.
//  Copyright (c) 2014 kovtash.com. All rights reserved.
//

#import "VKBaseBubbleCell.h"
#import "VKiOSVersionCheck.h"
#import <QuartzCore/QuartzCore.h>

@implementation VKBaseBubbleCell

- (void) setMessageDate:(NSDate *)messageDate{
    if (_messageDate != messageDate) {
        _messageDate = messageDate;
        self.bubbleView.messageRightHeader.text = [self.dateFormatter stringFromDate:_messageDate];
    }
}

#pragma mark - Class methods

+ (CGFloat) bubbleViewWidthMultiplier{
    return 0.9;
}

+ (UIEdgeInsets) edgeInsets{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

+ (instancetype) cellWithBubbleView:(VKBubbleView *) bubbleView reuseIdentifier:(NSString *) reuseIdentifier {
    
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDoesRelativeDateFormatting:YES];
    }
    
    VKBaseBubbleCell *cell = [[[self class] alloc] initWithBubbleView:bubbleView reuseIdentifier:reuseIdentifier];
    if (cell) {
        cell.backgroundColor = [UIColor clearColor];
        cell.dateFormatter = dateFormatter;
    }
    return cell;
}

+ (instancetype) inboundCellWithBubbleView:(VKBubbleView *) bubbleView reuseIdentifier:(NSString *) reuseIdentifier {
    VKBaseBubbleCell *cell = [[self class] cellWithBubbleView:bubbleView reuseIdentifier:reuseIdentifier];
    [cell setBubbleAlign:VKBubbleAlignLeft];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        UIColor *headerColor = [UIColor colorWithRed:0.5
                                               green:0.5
                                                blue:0.5
                                               alpha:0.5];
        cell.bubbleView.messageRightHeader.textColor = headerColor;
        cell.bubbleView.messageLeftHeader.textColor = headerColor;
    }
    else {
        cell.bubbleView.messageRightHeader.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
        cell.bubbleView.messageRightHeader.shadowOffset = CGSizeMake(0, -1);
        cell.bubbleView.messageRightHeader.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        cell.bubbleView.messageLeftHeader.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
        cell.bubbleView.messageLeftHeader.shadowOffset = CGSizeMake(0, -1);
        cell.bubbleView.messageLeftHeader.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }
    return cell;
}

+ (instancetype) outboundCellWithBubbleView:(VKBubbleView *) bubbleView reuseIdentifier:(NSString *) reuseIdentifier {
    VKBaseBubbleCell *cell = [[self class] cellWithBubbleView:bubbleView reuseIdentifier:reuseIdentifier];
    [cell setBubbleAlign:VKBubbleAlignRight];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        UIColor *headerColor = [UIColor colorWithRed:1
                                               green:1
                                                blue:1
                                               alpha:0.5];
        cell.bubbleView.messageRightHeader.textColor = headerColor;
        cell.bubbleView.messageLeftHeader.textColor = headerColor;
    }
    else {
        cell.bubbleView.messageRightHeader.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
        cell.bubbleView.messageRightHeader.shadowOffset = CGSizeMake(0, -1);
        cell.bubbleView.messageRightHeader.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        cell.bubbleView.messageLeftHeader.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
        cell.bubbleView.messageLeftHeader.shadowOffset = CGSizeMake(0, -1);
        cell.bubbleView.messageLeftHeader.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }
    return cell;
}

@end












