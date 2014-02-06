//
//  VKMenuControllerPresenter.h
//  VKMenuControllerPresenter
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VKMenuControllerPresenterDelegate <NSObject>
@optional
- (BOOL) canPerformAction:(SEL)action withSender:(id)sender;
- (BOOL) canPerformAction:(SEL)action withSender:(id)sender userInfo:(NSDictionary *) userInfo;
- (void) performAction:(SEL)action withSender:(id)sender userInfo:(NSDictionary *) userInfo;
@end

typedef void (^CompleteonBlock)(void);

@interface VKMenuControllerPresenter : UITextView
@property (nonatomic) BOOL shouldDisplayKeyboard;
@property (weak, nonatomic) UIView *parentView;
@property (nonatomic, readonly) BOOL isPresentingMenu;

- (void) dismissMenu;

- (void) showDefaultMenuForView:(UIView *) menuView
           returnFocusTo:(UIView *) firstResponder
              completeon:(CompleteonBlock) completeon;
- (void) showDefaultMenuWithResponder:(id <VKMenuControllerPresenterDelegate>) responder
                             userInfo:(NSDictionary *) userInfo
                               inView:(UIView *) targetView
                  returnFocusTo:(UIView *) firstResponder
                     completeon:(CompleteonBlock) completeon;
- (id) initWithParentView:(UIView *) parentView;
@end
