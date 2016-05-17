//
//  ZIMKeyboardTracker.h
//  Pods
//
//  Created by Vladislav Kovtash on 17/05/16.
//
//

#import <UIKit/UIKit.h>

@class ZIMKeyboardTracker;

@protocol ZIMKeyboardTrackerDelegate <NSObject>
@optional
- (void)trackerDetectedKeyboardWillShow:(ZIMKeyboardTracker *)tracker;
- (void)trackerDetectedKeyboardDidShow:(ZIMKeyboardTracker *)tracker;
- (void)trackerDetectedKeyboardWillHide:(ZIMKeyboardTracker *)tracker;
- (void)trackerDetectedKeyboardDidHide:(ZIMKeyboardTracker *)tracker;
- (void)trackerDetectedKeyboardWillChangeFrame:(ZIMKeyboardTracker *)tracker;
- (void)trackerDetectedKeyboardDidChangeFrame:(ZIMKeyboardTracker *)tracker;
@end


@interface ZIMKeyboardTracker : NSObject
@property (readonly, nonatomic) BOOL isKeyboardHidden;
@property (readonly, nonatomic) CGRect keyboardFrame;
@property (readonly, nonatomic) UIViewAnimationCurve lastAnimationCurve;
@property (readonly, nonatomic) NSTimeInterval lastAnimationDuration;
@property (weak, nonatomic) id <ZIMKeyboardTrackerDelegate> delegate;

- (CGRect)keyboardRectInView:(UIView *)view;
@end
