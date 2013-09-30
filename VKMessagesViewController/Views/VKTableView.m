//
//  VKTableView.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKTableView.h"

@interface VKTableView(){
    CGFloat _newVeticalOffsetStorageFrame;
    NSIndexPath *_lastVisibleRow;
    BOOL _offsetRestorationRequired;
}
@end

@implementation VKTableView

- (void) setFrame:(CGRect)frame{
    if (self.frame.size.width != frame.size.width) {
        _offsetRestorationRequired = YES;
        if (self.frame.size.height > self.contentSize.height) {
            _lastVisibleRow = [self indexPathForRowAtPoint:CGPointMake(0, self.contentSize.height + self.contentOffset.y - 10 )];
        }
        else{
            _lastVisibleRow = [self indexPathForRowAtPoint:CGPointMake(0, self.frame.size.height + self.contentOffset.y - 10 )];
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
    if (self.contentSize.height >  self.bounds.size.height - self.contentInset.top) {
        [self setContentOffset:CGPointMake(self.contentOffset.x,
                                           self.contentSize.height - self.bounds.size.height)
                      animated:animated];
    }
}
@end

