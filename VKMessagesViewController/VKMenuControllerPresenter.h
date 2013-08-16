//
//  VKMenuControllerPresenter.h
//  VKMenuControllerPresenter
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CompleteonBlock)(void);

@interface VKMenuControllerPresenter : UITextView
@property (nonatomic) BOOL shouldDisplayKeyboard;
@property (weak,nonatomic) UIView *parentView;

- (void) showDefaultMenuForView:(UIView *) menuView
           returnFocusTo:(UIView *) firstResponder
              completeon:(CompleteonBlock) completeon;
- (id) initWithParentView:(UIView *) parentView;
@end
