//
//  VKMessagesViewController.h
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIInputToolbar.h"
#import "VKTableView.h"
#import "VKMenuControllerPresenter.h"

@interface VKMessagesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,
                                                        UIInputToolbarDelegate>

@property (strong, nonatomic) VKTableView *tableView;
@property (strong, nonatomic) UIInputToolbar *messageToolbar;
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
- (void) inputButtonPressed:(UIInputToolbar *)toolbar;
- (void) plusButtonPressed:(UIInputToolbar *)toolbar;
- (void) inputToolbar:(UIInputToolbar *)inputToolbar DidChangeHeight:(CGFloat)height;
- (void) inputToolbarDidBeginEditing:(UIInputToolbar *)inputToolbar;

#pragma mark - cell menu
- (BOOL) shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL) canPerformAction:(SEL)action
        forRowAtIndexPath:(NSIndexPath *)indexPath
               withSender:(id)sender;
- (void) performAction:(SEL)action
     forRowAtIndexPath:(NSIndexPath *)indexPath
            withSender:(id)sender;
@end
