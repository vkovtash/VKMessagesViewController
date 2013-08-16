//
//  UIViewController+firstResponder.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "UIViewController+firstResponder.h"
#import "UIResponder+FirstResponder.h"

@implementation UIViewController (firstResponder)
- (UIView *) firstResponder{
    UIResponder *first = UIApplication.sharedApplication.currentFirstResponder;
    if ([first isKindOfClass:UIView.class] && [(id)first isDescendantOfView:self.view]) {
        return (UIView *) first;
    }
    else{
        return nil;
    }
}
@end
