//
//  UIActionSheet+VKBlocks.m
//  PTTMobile
//
//  Created by Vlad Kovtash on 22/11/13.
//  Copyright (c) 2013 ptt. All rights reserved.
//

#import "UIActionSheet+VKBlocks.h"
#import <objc/runtime.h>

static void *VKActionSheetViewKey = "VKActionSheetView";

@interface UIActionSheet () <UIActionSheetDelegate>
@end

@implementation UIActionSheet (PTTBlocks)

- (id) initWithTitle:(NSString *)aTitle
   cancelButtonTitle:(NSString *)aCancelTitle
destructiveButtonTitle:(NSString *) aDestructiveTitle
   otherButtonTitles:(NSString *)otherTitles,... {
    __weak __typeof(&*self) weakSelf = self;
    self = [self initWithTitle:aTitle
                      delegate:weakSelf
             cancelButtonTitle:nil
        destructiveButtonTitle:nil
             otherButtonTitles:nil];
    if (self) {
        if (otherTitles != nil) {
            [self addButtonWithTitle:otherTitles];
            va_list args;
            va_start(args, otherTitles);
            NSString * title = nil;
            while((title = va_arg(args, NSString*))) {
                [self addButtonWithTitle:title];
            }
            va_end(args);
        }
    }
    
    if (aDestructiveTitle) {
        [self addButtonWithTitle:aDestructiveTitle];
        self.destructiveButtonIndex = self.numberOfButtons - 1;
    }
    
    if (aCancelTitle) {
        [self addButtonWithTitle:aCancelTitle];
        self.cancelButtonIndex = self.numberOfButtons - 1;
    }
    
    return self;
}

- (void) associateHandler:(VKActionSheetDismissedHandler)handler {
    objc_setAssociatedObject(self, VKActionSheetViewKey, handler, OBJC_ASSOCIATION_COPY);
}

- (void)showFromTabBar:(UITabBar *)view withDismissHandler:(VKActionSheetDismissedHandler)handler {
    [self associateHandler:handler];
    [self showFromTabBar:view];
}

- (void)showFromToolbar:(UIToolbar *)view withDismissHandler:(VKActionSheetDismissedHandler)handler {
    [self associateHandler:handler];
    [self showFromToolbar:view];
}

- (void)showInView:(UIView *)view withDismissHandler:(VKActionSheetDismissedHandler)handler {
    [self associateHandler:handler];
    [self showInView:view];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated withDismissHandler:(VKActionSheetDismissedHandler)handler {
    [self associateHandler:handler];
    [self showFromRect:rect inView:view animated:animated];
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated withDismissHandler:(VKActionSheetDismissedHandler)handler {
    [self associateHandler:handler];
    [self showFromBarButtonItem:item animated:animated];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    VKActionSheetDismissedHandler handler = objc_getAssociatedObject(self, VKActionSheetViewKey);
    handler ? handler(buttonIndex, buttonIndex == actionSheet.cancelButtonIndex, buttonIndex == actionSheet.destructiveButtonIndex) : nil;
}

@end
