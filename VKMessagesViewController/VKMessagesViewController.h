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

@interface VKMessagesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,
                                                        ZIMInputToolbarDelegate>

@property (strong, nonatomic) VKTableView *tableView;
@property (strong, nonatomic) ZIMInputToolbar *messageToolbar;
@property (strong, nonatomic) UIView *alternativeInputView; //view shown on plus button tap
@property (readwrite, nonatomic) NSString *messagePlaceholder;
@property (strong, nonatomic) VKMenuControllerPresenter *menuPresenter;
@property (strong, nonatomic) NSArray *cellMenuItems;

- (void) scrollTableViewToBottomAnimated:(BOOL)animated;
- (void) alighKeyboardControlsToRect:(CGRect)rect animated:(BOOL)animated;
- (void) dismissKeyboard;

#pragma mark - keyboard notifications
- (void) keyboardWillShow:(NSNotification *) notification;
- (void) keyboardWillHide:(NSNotification *) notification;
- (void) keyboardDidShow:(NSNotification *) notification;
- (void) keyboardDidHide:(NSNotification *) notification;
- (void) keyboardWillChangeFrame:(CGRect) frame animated:(BOOL) animated;

#pragma mark - messageToolbal delegate
- (void) inputButtonPressed:(ZIMInputToolbar *)toolbar;
- (void) plusButtonPressed:(ZIMInputToolbar *)toolbar;
- (void) inputToolbar:(ZIMInputToolbar *)inputToolbar didChangeHeight:(CGFloat)height;
- (void) inputToolbarDidBeginEditing:(ZIMInputToolbar *)inputToolbar;

#pragma mark - cell menu
- (BOOL) shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL) canPerformAction:(SEL)action
        forRowAtIndexPath:(NSIndexPath *)indexPath
               withSender:(id)sender;
- (void) performAction:(SEL)action
     forRowAtIndexPath:(NSIndexPath *)indexPath
            withSender:(id)sender;
@end
