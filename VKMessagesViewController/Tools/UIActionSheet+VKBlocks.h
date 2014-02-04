//
//  UIActionSheet+VKBlocks.h
//  PTTMobile
//
//  Created by Vlad Kovtash on 22/11/13.
//  Copyright (c) 2013 ptt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^VKActionSheetDismissedHandler) (NSInteger selectedIndex, BOOL didCancel, BOOL destructive);

@interface UIActionSheet (VKBlocks)
- (id) initWithTitle:(NSString *)aTitle
   cancelButtonTitle:(NSString *)aCancelTitle
destructiveButtonTitle:(NSString *) aDestructiveTitle
   otherButtonTitles:(NSString *)otherTitles,...NS_REQUIRES_NIL_TERMINATION;

- (void)showFromTabBar:(UITabBar *)view withDismissHandler:(VKActionSheetDismissedHandler)handler;
- (void)showFromToolbar:(UIToolbar *)view withDismissHandler:(VKActionSheetDismissedHandler)handler;
- (void)showInView:(UIView *)view withDismissHandler:(VKActionSheetDismissedHandler)handler;
- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated withDismissHandler:(VKActionSheetDismissedHandler)handler;
- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated withDismissHandler:(VKActionSheetDismissedHandler)handler;
@end
