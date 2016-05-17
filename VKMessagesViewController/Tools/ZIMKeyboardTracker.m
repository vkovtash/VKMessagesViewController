//
//  ZIMKeyboardTracker.m
//  Pods
//
//  Created by Vladislav Kovtash on 17/05/16.
//
//

#import "ZIMKeyboardTracker.h"

@implementation ZIMKeyboardTracker

- (instancetype)init {
    self = [super init];
    if (self) {
        [self registerForKeyboardNotifications];
        _isKeyboardHidden = YES;
    }

    return self;
}

- (void)dealloc {
    [self unregisterFromKeyboardNotifications];
}

- (void)registerForKeyboardNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)unregisterFromKeyboardNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [defaultCenter removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [defaultCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [defaultCenter removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [defaultCenter removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [defaultCenter removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    _keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _lastAnimationCurve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    _lastAnimationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    _isKeyboardHidden = NO;

    if ([self.delegate respondsToSelector:@selector(trackerDetectedKeyboardWillShow:)]) {
        [self.delegate trackerDetectedKeyboardWillShow:self];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _lastAnimationCurve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    _lastAnimationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    _isKeyboardHidden = YES;

    if ([self.delegate respondsToSelector:@selector(trackerDetectedKeyboardWillHide:)]) {
        [self.delegate trackerDetectedKeyboardWillHide:self];
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    _keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _lastAnimationCurve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    _lastAnimationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];

    if ([self.delegate respondsToSelector:@selector(trackerDetectedKeyboardWillChangeFrame:)]) {
        [self.delegate trackerDetectedKeyboardWillChangeFrame:self];
    }
}

- (void)keyboardDidShow:(NSNotification *)notification {
    _keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _isKeyboardHidden = NO;

    if ([self.delegate respondsToSelector:@selector(trackerDetectedKeyboardDidShow:)]) {
        [self.delegate trackerDetectedKeyboardDidShow:self];
    }
}

- (void)keyboardDidHide:(NSNotification *)notification {
    _keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _isKeyboardHidden = YES;

    if ([self.delegate respondsToSelector:@selector(trackerDetectedKeyboardDidHide:)]) {
        [self.delegate trackerDetectedKeyboardDidHide:self];
    }
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification {
    _keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    if ([self.delegate respondsToSelector:@selector(trackerDetectedKeyboardDidChangeFrame:)]) {
        [self.delegate trackerDetectedKeyboardDidChangeFrame:self];
    }
}

- (CGRect)keyboardRectInView:(UIView *)view {
    if (view) {
        return [view convertRect:self.keyboardFrame fromView:view.window];
    }
    return CGRectZero;
}

@end
