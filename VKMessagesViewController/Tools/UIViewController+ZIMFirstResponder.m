//
//  UIViewController+firstResponder.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "UIViewController+ZIMFirstResponder.h"
#import "UIResponder+ZIMFirstResponder.h"

@implementation UIViewController (ZIMFirstResponder)

- (UIView *)zim_firstResponder {
    UIResponder *first = UIApplication.sharedApplication.zim_currentFirstResponder;
    if ([first isKindOfClass:UIView.class] && [(id)first isDescendantOfView:self.view]) {
        return (UIView *) first;
    }
    return nil;
}

@end
