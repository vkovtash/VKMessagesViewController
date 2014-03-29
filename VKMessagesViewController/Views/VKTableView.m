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

@interface VKTableView(){
    CGFloat _newVeticalOffsetStorageFrame;
    NSIndexPath *_lastVisibleRow;
    BOOL _offsetRestorationRequired;
}
@end

@implementation VKTableView

- (void) setContentInset:(UIEdgeInsets)contentInset{
    CGFloat bottomOffset = (self.contentSize.height - self.bounds.size.height + self.contentInset.bottom) - self.contentOffset.y;
    BOOL shouldCorrect = (bottomOffset > kInsetCorrectionTollerance) || (bottomOffset < kInsetCorrectionTollerance && self.contentInset.bottom < contentInset.bottom);
    
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

- (void) setFrame:(CGRect)frame{
    if (self.frame.size.width != frame.size.width) {
        _offsetRestorationRequired = YES;
        if (self.frame.size.height > self.contentSize.height + self.contentInset.bottom) {
            _lastVisibleRow = [self indexPathForRowAtPoint:CGPointMake(0, self.contentSize.height + self.contentOffset.y - kRotationRestorationTollerance - self.contentInset.top)];
        }
        else{
            _lastVisibleRow = [self indexPathForRowAtPoint:CGPointMake(0, self.frame.size.height + self.contentOffset.y - kRotationRestorationTollerance - self.contentInset.top)];
        }
    }
    else if (self.frame.size.height != frame.size.height) {
        _offsetRestorationRequired = YES;
            if (self.frame.size.height > self.contentSize.height) {
                _newVeticalOffsetStorageFrame = 0;
            }
            else{
                _newVeticalOffsetStorageFrame = self.contentSize.height - self.frame.size.height - self.contentOffset.y;
            }
    }
    else{
        _offsetRestorationRequired = NO;
    }

    [super setFrame:frame];
    
    if (!_offsetRestorationRequired) {
        return;
    }
    
    if (_lastVisibleRow) {
        if (_lastVisibleRow.section < [self numberOfSections] && _lastVisibleRow.row < [self numberOfRowsInSection:_lastVisibleRow.section]){
            [self scrollToRowAtIndexPath:_lastVisibleRow
                        atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        else {
            [self scrollToBottom];
        }
        _lastVisibleRow = nil;
    }
    else {
        if (self.contentSize.height > self.frame.size.height
            && (self.contentSize.height - self.frame.size.height - _newVeticalOffsetStorageFrame) > -self.contentInset.top) {
            [self setContentOffset:CGPointMake(self.contentOffset.x,
                                               self.contentSize.height - self.frame.size.height - _newVeticalOffsetStorageFrame)];
        }
        else{
            [self setContentOffset:CGPointMake(self.contentOffset.x, -self.contentInset.top)];
        }
    }
}

- (void) scrollToBottom{
    [self scrollToBottomAnimated:NO];
}

- (void) scrollToBottomAnimated:(BOOL) animated{
    if (self.contentSize.height + self.contentInset.bottom + self.contentInset.top > self.bounds.size.height){
        [self setContentOffset:CGPointMake(self.contentOffset.x,
                                           self.contentSize.height - self.bounds.size.height + self.contentInset.bottom)
                      animated:animated];
    }
}
@end

