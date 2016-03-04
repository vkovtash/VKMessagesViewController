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

- (void)setNormalBackgroundImage:(UIImage *)normalBackgroundImage {
    _normalBackgroundImage = normalBackgroundImage;
    [self setNeedsLayout];
    [self applyIsSelected];
}

- (void)setSelectedBackgroundImage:(UIImage *)selectedBackgroundImage {
    _selectedBackgroundImage = selectedBackgroundImage;
    [self setNeedsLayout];
    [self applyIsSelected];
}

- (void)setSelected:(BOOL)selected {
    _isSelected = selected;
    [self applyIsSelected];
}

- (void)setProperties:(VKBubbleViewProperties *)properties{
    if (_properties != properties) {
        _properties = properties;
        [self setNeedsLayout];
    }
}

- (CGSize)sizeConstrainedToWidth:(CGFloat) width {
    return CGSizeMake(44, 44);
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.background.backgroundColor = backgroundColor;
}

#pragma mark - Private properties

- (UIImageView *)background {
    if (!_background) {
        _background = [[UIImageView alloc] init];
    }
    return _background;
}

#pragma mark - Private methods

- (void)applyIsSelected {
    if (_isSelected && _selectedBackgroundImage) {
        self.background.image = self.selectedBackgroundImage;
    }
    else {
        self.background.image = self.normalBackgroundImage;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIEdgeInsets insets = self.properties.edgeInsets;
    CGRect rect = self.bounds;
    rect.origin.x = insets.left;
    rect.origin.y = insets.top;
    rect.size.width -= insets.left + insets.right;
    rect.size.height -= insets.top + insets.bottom;
    self.messageBody.frame = rect;
    self.background.frame = self.bounds;
}

#pragma mark - UIView methods

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma - mark Init

- (void)postInit {
    [self addSubview:self.background];
    [self addSubview:self.messageBody];
    self.autoresizesSubviews = NO;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self postInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self postInit];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self postInit];
    }
    return self;
}

- (instancetype)initWithBubbleProperties:(VKBubbleViewProperties *)properties {
    self = [super initWithFrame:CGRectMake(0, 0, 400, 400)];
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
