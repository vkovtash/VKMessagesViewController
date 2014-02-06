//
//  VKMenuControllerPresenter.m
//  VKMenuControllerPresenter
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKMenuControllerPresenter.h"

@interface VKMenuControllerPresenter()
@property (weak,nonatomic) id<VKMenuControllerPresenterDelegate> menuDisplayingResponder;
@property (weak,nonatomic) UIView *previousFirsResponder;
@property (strong,nonatomic) CompleteonBlock completeonBlock;
@property (copy, nonatomic) NSDictionary *userInfo;
@end

@implementation VKMenuControllerPresenter
@synthesize isPresentingMenu = _isPresentingMenu;

#pragma mark - Publick Properties

- (void) setParentView:(UIView *)parentView{
    [self removeFromSuperview];
    _parentView = parentView;
    [_parentView addSubview:self];
}

- (BOOL) shouldDisplayKeyboard{
    return self.editable;
}

- (void) setShouldDisplayKeyboard:(BOOL)shouldDisplayKeyboard{
    self.editable = shouldDisplayKeyboard;
}

#pragma mark - Publick methods

- (void) showDefaultMenuForView:(UIView *) menuView
           returnFocusTo:(UIView *) firstResponder
              completeon:(void(^)(void)) completeon{
    [self showDefaultMenuWithResponder:(id <VKMenuControllerPresenterDelegate>)menuView
                              userInfo: nil inView:menuView
                         returnFocusTo:firstResponder
                            completeon:completeon];
}

- (void) showDefaultMenuWithResponder:(id) responder
                             userInfo:(NSDictionary *) userInfo
                               inView:(UIView *) targetView
                        returnFocusTo:(UIView *) firstResponder
                           completeon:(CompleteonBlock) completeon {
    
    self.userInfo = [userInfo copy];
    self.menuDisplayingResponder = responder;
    self.completeonBlock = completeon;
    if (firstResponder != self) {
        self.previousFirsResponder = firstResponder;
        if ([self.previousFirsResponder conformsToProtocol:@protocol(UITextInputTraits)]){
            id <UITextInputTraits> textInput = (id <UITextInputTraits>)self.previousFirsResponder;
            self.keyboardType = textInput.keyboardType;
            self.returnKeyType = textInput.returnKeyType;
            self.keyboardAppearance = textInput.keyboardAppearance;
        }
    }
    
    _isPresentingMenu = YES;
    [self becomeFirstResponder];
    
    __weak __typeof(&*self) weakSelf = self;
    double delayInSeconds = 0.05;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [[NSNotificationCenter defaultCenter] addObserver:weakSelf
                                                 selector:@selector(willHideEditMenu:)
                                                     name:UIMenuControllerWillHideMenuNotification
                                                   object:menuController];
        [menuController setTargetRect:targetView.frame inView:targetView.superview];
        [menuController setMenuVisible:YES animated:YES];
    });
}

- (void) dismissMenu {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self resignFirstResponder];
    if (self.previousFirsResponder) {
        [self.previousFirsResponder becomeFirstResponder];
        self.previousFirsResponder = nil;
    }
    self.completeonBlock ? self.completeonBlock() : nil;
    self.completeonBlock = nil;
    self.userInfo = nil;
    _isPresentingMenu = NO;
}

#pragma mark - UIResponderStandardEditActions

- (BOOL) canPerformAction:(SEL)action
               withSender:(id)sender {
    if ([self.menuDisplayingResponder respondsToSelector:@selector(canPerformAction:withSender:userInfo:)]){
        return ([self.menuDisplayingResponder canPerformAction:action withSender:sender userInfo:self.userInfo]);
    }
    else if ([self.menuDisplayingResponder respondsToSelector:@selector(canPerformAction:withSender:)]) {
        return [self.menuDisplayingResponder canPerformAction:action withSender:sender];
    }
    else{
        return NO;
    }
}

#pragma mark - UIResponderStandardEditActions

- (void) performAction:(SEL)action withSender:(id)sender {
    if ([self.menuDisplayingResponder respondsToSelector:@selector(performAction:withSender:userInfo:)]) {
        [self.menuDisplayingResponder performAction:action withSender:sender userInfo:self.userInfo];
    }
    else if ([self.menuDisplayingResponder respondsToSelector:action]) {
        IMP imp = [(NSObject *)self.menuDisplayingResponder methodForSelector:action];
        void (*func)(id, SEL) = (void *)imp;
        func(self.menuDisplayingResponder, action);
    }
}

- (void) copy:(id)sender {
    [self performAction:@selector(copy:) withSender:sender];
}

- (void) cut:(id)sender {
    [self performAction:@selector(cut:) withSender:sender];
}

- (void) delete:(id)sender {
    [self performAction:@selector(delete:) withSender:sender];
}

#pragma mark - NSNotificationCenter

- (void) willHideEditMenu:(NSNotification *) notification{
    [self dismissMenu];
}

#pragma mark - Init methods

- (void) postInit{
    self.frame = CGRectZero;
    self.editable = NO;
}

- (id) init{
    self = [super init];
    if (self) {
        [self postInit];
    }
    return self;
}

- (id) initWithParentView:(UIView *) parentView{
    self = [super init];
    if (self) {
        [self postInit];
        self.parentView = parentView;
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self postInit];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self postInit];
    }
    return self;
}

@end





















