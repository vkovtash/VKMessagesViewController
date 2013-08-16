//
//  VKMenuControllerPresenter.m
//  VKMenuControllerPresenter
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKMenuControllerPresenter.h"

@interface VKMenuControllerPresenter()
@property (weak,nonatomic) UIView *menuDisplayingView;
@property (weak,nonatomic) UIView *previousFirsResponder;
@property (strong,nonatomic) CompleteonBlock completeonBlock;
@end

@implementation VKMenuControllerPresenter

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
    self.menuDisplayingView = menuView;
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
    
    [self becomeFirstResponder];
    
    __weak __typeof(&*self) weakSelf = self;
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [[NSNotificationCenter defaultCenter] addObserver:weakSelf
                                                 selector:@selector(willHideEditMenu:)
                                                     name:UIMenuControllerWillHideMenuNotification
                                                   object:menuController];
        [menuController setTargetRect:menuView.frame inView:menuView.superview];
        [menuController setMenuVisible:YES animated:YES];
    });
}

#pragma mark - UIResponderStandardEditActions

- (BOOL) canPerformAction:(SEL)action
               withSender:(id)sender
{
    if ([self.menuDisplayingView respondsToSelector:@selector(canPerformAction:withSender:)]) {
        return ([self.menuDisplayingView canPerformAction:action withSender:sender]);
    }
    else{
        return NO;
    }
}

#pragma mark - UIResponderStandardEditActions

- (void) copy:(id)sender {
    if ([self.menuDisplayingView respondsToSelector:@selector(copy:)]) {
        [(id)self.menuDisplayingView copy:sender];
    }
}

- (void) cut:(id)sender {
    if ([self.menuDisplayingView respondsToSelector:@selector(cut:)]) {
        [(id)self.menuDisplayingView cut:sender];
    }
}

- (void) delete:(id)sender {
    if ([self.menuDisplayingView respondsToSelector:@selector(delete:)]) {
        [(id)self.menuDisplayingView delete:sender];
    }
}

- (void) select:(id)sender {
    if ([self.menuDisplayingView respondsToSelector:@selector(select:)]) {
        [(id)self.menuDisplayingView select:sender];
    }
}

- (void) selectAll:(id)sender {
    if ([self.menuDisplayingView respondsToSelector:@selector(selectAll:)]) {
        [(id)self.menuDisplayingView selectAll:sender];
    }
}

- (void) toggleBoldface:(id)sender {
    if ([self.menuDisplayingView respondsToSelector:@selector(toggleBoldface:)]) {
        [(id)self.menuDisplayingView toggleBoldface:sender];
    }
}

- (void) toggleItalics:(id)sender {
    if ([self.menuDisplayingView respondsToSelector:@selector(toggleItalics:)]) {
        [(id)self.menuDisplayingView toggleItalics:sender];
    }
}

- (void) toggleUnderline:(id)sender {
    if ([self.menuDisplayingView respondsToSelector:@selector(toggleUnderline:)]) {
        [(id)self.menuDisplayingView toggleUnderline:sender];
    }
}

- (void) makeTextWritingDirectionLeftToRight:(id)sender {
    if ([self.menuDisplayingView respondsToSelector:@selector(makeTextWritingDirectionLeftToRight:)]) {
        [(id)self.menuDisplayingView makeTextWritingDirectionLeftToRight:sender];
    }
}

- (void) makeTextWritingDirectionRightToLeft:(id)sender {
    if ([self.menuDisplayingView respondsToSelector:@selector(makeTextWritingDirectionRightToLeft:)]) {
        [(id)self.menuDisplayingView makeTextWritingDirectionRightToLeft:sender];
    }
}

#pragma mark - NSNotificationCenter

- (void) willHideEditMenu:(NSNotification *) notification{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:notification.object];
    [self resignFirstResponder];
    if (self.previousFirsResponder) {
        [self.previousFirsResponder becomeFirstResponder];
        self.previousFirsResponder = nil;
    }
    self.completeonBlock ? self.completeonBlock() : nil;
    self.completeonBlock = nil;
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





















