//
//  VKBobbleView.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKBubbleView.h"
#import "UIActionSheet+VKBlocks.h"

@interface VKBubbleView()
@property (strong,nonatomic) UIImageView *background;
@end

@implementation VKBubbleView

#pragma mark - Publick Properties

- (void) setNormalBackgroundImage:(UIImage *)normalBackgroundImage {
    _normalBackgroundImage = normalBackgroundImage;
    [self applyProperties];
}

- (void) setSelectedBackgroundImage:(UIImage *)selectedBackgroundImage {
    _selectedBackgroundImage = selectedBackgroundImage;
    [self applyProperties];
}

- (void) setSelected:(BOOL)selected {
    _isSelected = selected;
    [self applyIsSelected];
}

- (void) setProperties:(VKBubbleViewProperties *)properties{
    if (_properties != properties) {
        _properties = properties;
        [self applyProperties];
    }
}

- (CGFloat) widthConstrainedToWidth:(CGFloat) width {
    return 50;
}

#pragma mark - Private properties

- (UIImageView *) background{
    if (!_background) {
        _background = [[UIImageView alloc] init];
    }
    return _background;
}

#pragma mark - Private methods

- (void) applyIsSelected {
    if (_isSelected && _selectedBackgroundImage) {
        self.background.image = self.selectedBackgroundImage;
    }
    else {
        self.background.image = self.normalBackgroundImage;
    }
}

- (void) applyProperties {
    self.background.frame = self.bounds;
    CGRect rect = self.messageBody.frame;
    rect.origin.x = self.properties.edgeInsets.left;
    rect.origin.y = self.properties.edgeInsets.top;
    rect.size.width = self.bounds.size.width - self.properties.edgeInsets.left - self.properties.edgeInsets.right;
    rect.size.height = self.bounds.size.height - self.properties.edgeInsets.top - self.properties.edgeInsets.bottom;
    self.messageBody.frame = rect;
}

#pragma mark - UIView methods

- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copy:));
}

#pragma - mark Init

- (void) postInit{
    [self addSubview:self.background];
    [self addSubview:self.messageBody];
    
    self.autoresizesSubviews = YES;
    self.messageBody.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.background.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [self applyProperties];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self postInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self postInit];
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
        [self postInit];
    }
    return self;
}

- (id) initWithBubbleProperties:(VKBubbleViewProperties *) properties{
    self = [super initWithFrame:CGRectMake(0, 0, 80, 80)];
    if (self) {
        self.properties = properties;
        [self postInit];
    }
    return self;
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url{
    [[UIApplication sharedApplication] openURL:url];
}

- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithPhoneNumber:(NSString *)phoneNumber{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:phoneNumber cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Call", nil];
    [actionSheet showInView:self withDismissHandler:^(NSInteger selectedIndex, BOOL isCancel, BOOL isDestructive){
        if (!isCancel && !isDestructive) {
            NSString *cleanedString = [[phoneNumber
                                        componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]]
                                       componentsJoinedByString:@""];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", cleanedString]]];
        }
    }];
}

@end

















