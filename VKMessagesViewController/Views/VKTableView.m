//
//  VKTableView.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKTableView.h"

static CGFloat kInsetCorrectionTollerance = 150;
static CGFloat kRotationRestorationTollerance = 10;

@interface VKTableView() {
    NSIndexPath *_lastVisibleRow;
    CGRect _previousBounds;
}

@end

@implementation VKTableView

- (void)setContentInset:(UIEdgeInsets)contentInset {
    CGFloat bottomOffset = (self.contentSize.height - self.bounds.size.height + self.contentInset.bottom) - self.contentOffset.y;
    BOOL shouldCorrect = (bottomOffset > kInsetCorrectionTollerance) ||
                         (bottomOffset < kInsetCorrectionTollerance && self.contentInset.bottom < contentInset.bottom);
    
    CGFloat offsetCorrection = 0;
    if (self.contentSize.height < self.bounds.size.height - self.contentInset.top - self.contentInset.bottom) {
        //content is smaller than current scrolling window
        offsetCorrection = self.contentSize.height - (self.bounds.size.height - contentInset.top - contentInset.bottom);
    }
    else {
        offsetCorrection = contentInset.bottom - self.contentInset.bottom;
    }
    
    [super setContentInset:contentInset];
    
    if (shouldCorrect) {
        CGPoint offset = self.contentOffset;
        offset.y += offsetCorrection;
        if (offset.y < -self.contentInset.top) {
            offset.y = -self.contentInset.top;
        }
        self.contentOffset = offset;
    }
}

- (void)setFrame:(CGRect)frame {
    _previousBounds = self.bounds;

    CGFloat height = CGRectGetHeight(self.bounds);

    if (height > self.contentSize.height + self.contentInset.bottom) {
        height = self.contentSize.height;
    }

    CGPoint bottomPoint = CGPointMake(0, height + self.contentOffset.y - kRotationRestorationTollerance - self.contentInset.bottom);

    _lastVisibleRow = [self indexPathForRowAtPoint:bottomPoint];

    [super setFrame:frame];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!_lastVisibleRow || CGRectEqualToRect(_previousBounds, self.bounds)) {
        return;
    }

    CGFloat height = CGRectGetHeight(self.bounds);

    if (_lastVisibleRow.section < [self numberOfSections] &&
        _lastVisibleRow.row < [self numberOfRowsInSection:_lastVisibleRow.section] - 1) {
        [self scrollToRowAtIndexPath:_lastVisibleRow atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    else {
        [self scrollToBottom];
    }

    _lastVisibleRow = nil;
    _previousBounds = CGRectZero;
}

- (void)scrollToBottom {
    [self scrollToBottomAnimated:NO];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    if (self.contentSize.height + self.contentInset.bottom + self.contentInset.top > self.bounds.size.height) {
        [self setContentOffset:CGPointMake(self.contentOffset.x,
                                           self.contentSize.height - self.bounds.size.height + self.contentInset.bottom)
                      animated:animated];
    }
}

@end
