//
//  VKMessagesViewController.h
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZIMInputToolbar.h"
#import "VKTableView.h"
#import "VKMenuControllerPresenter.h"

@interface VKMessagesViewController : UIViewController <UITableViewDataSource,
                                                        UITableViewDelegate,
                                                        ZIMInputToolbarDelegate>
@property (strong, nonatomic) VKTableView *tableView;
@property (strong, nonatomic) ZIMInputToolbar *messageToolbar;
@property (weak, nonatomic) UIView *keyboardAttachedView;
@property (readwrite, nonatomic) NSString *messagePlaceholder;
@property (strong, nonatomic) VKMenuControllerPresenter *menuPresenter;
@property (strong, nonatomic) NSArray *cellMenuItems;
@property (readonly, nonatomic) CGFloat keyboardPullDownThresholdOffset;
@property (readonly, nonatomic) CGFloat topInset;
@property (readonly, nonatomic) CGFloat bottomInset; // Calculated as top edge of keyboardAttachedView

- (void)onAppear;
- (void)onDisappear;
- (void)scrollTableViewToBottomAnimated:(BOOL)animated;
- (void)alighKeyboardControlsToRect:(CGRect)rect animated:(BOOL)animated;
- (void)dismissKeyboard;
- (void)applyBottomInset;
- (void)applyTopInset;

#pragma mark - Keyboard notifications

- (void)registerForKeyboardNotifications;
- (void)unregisterFromKeyboardNotifications;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)keyboardDidShow:(NSNotification *)notification;
- (void)keyboardDidHide:(NSNotification *)notification;
- (void)keyboardWillChangeFrame:(CGRect)frame animated:(BOOL)animated;

#pragma mark - MessageToolbal delegate

- (void)inputButtonPressed:(ZIMInputToolbar *)toolbar;
- (void)inputToolbar:(ZIMInputToolbar *)inputToolbar didChangeHeight:(CGFloat)height;
- (void)inputToolbarDidBeginEditing:(ZIMInputToolbar *)inputToolbar;

#pragma mark - Cell menu

- (BOOL)shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender;
- (void)performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender;
@end
