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

- (UILabel *) messageRightHeader{
    if (!_messageRightHeader) {
        _messageRightHeader = [[UILabel alloc] init];
        _messageRightHeader.backgroundColor = [UIColor clearColor];
        _messageRightHeader.textAlignment = NSTextAlignmentRight;
        _messageRightHeader.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
        _messageRightHeader.shadowOffset = CGSizeMake(0, -1);
        _messageRightHeader.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }
    return _messageRightHeader;
}

- (UILabel *) messageLeftHeader{
    if (!_messageLeftHeader) {
        _messageLeftHeader = [[UILabel alloc] init];
        _messageLeftHeader.backgroundColor = [UIColor clearColor];
        _messageLeftHeader.textAlignment = NSTextAlignmentLeft;
        _messageLeftHeader.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
        _messageLeftHeader.shadowOffset = CGSizeMake(0, -1);
        _messageLeftHeader.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }
    return _messageLeftHeader;
}

- (UIImage *) backgroundImage{
    return self.background.image;
}

- (void) setBackgroundImage:(UIImage *)backgroundImage{
    self.background.image = backgroundImage;
}

- (void) setProperties:(VKBubbleViewProperties *)properties{
    if (_properties != properties) {
        _properties = properties;
        [self applyProperties];
    }
}

- (CGFloat) estimatedWidthWithMaximumWidth:(CGFloat) maximimWidth {
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

- (void) applyProperties {
    self.messageRightHeader.font =  self.properties.headerFont;
    self.messageLeftHeader.font = self.properties.headerFont;
    
    CGRect rect;
    
    self.background.frame = self.bounds;
    rect = self.messageRightHeader.frame;
    rect.origin.x = self.properties.edgeInsets.left;
    rect.origin.y = self.properties.edgeInsets.top;
    rect.size.width = self.bounds.size.width - self.properties.edgeInsets.left - self.properties.edgeInsets.right;
    rect.size.height = self.properties.estimatedHeaderHeigth;
    self.messageRightHeader.frame = rect;
    
    rect = self.messageLeftHeader.frame;
    rect.origin.x = self.properties.edgeInsets.left;
    rect.origin.y = self.properties.edgeInsets.top;
    rect.size.width = self.bounds.size.width - self.properties.edgeInsets.left - self.properties.edgeInsets.right;
    rect.size.height = self.properties.estimatedHeaderHeigth;
    self.messageLeftHeader.frame = rect;
    
    rect = self.messageBody.frame;
    rect.origin.x = self.properties.edgeInsets.left;
    rect.origin.y = self.messageRightHeader.frame.size.height + self.messageRightHeader.frame.origin.y;
    rect.size.width = self.bounds.size.width - self.properties.edgeInsets.left - self.properties.edgeInsets.right;
    rect.size.height = self.bounds.size.height - self.messageRightHeader.frame.size.height - self.messageRightHeader.frame.origin.y - self.properties.edgeInsets.bottom;
    self.messageBody.frame = rect;
    
}

#pragma mark - UIView methods

- (BOOL) canBecomeFirstResponder{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action
              withSender:(id)sender
{
    return (action == @selector(copy:));
}

#pragma - mark Init

- (void) postInit{
    [self addSubview:self.background];
    [self addSubview:self.messageRightHeader];
    [self addSubview:self.messageLeftHeader];
    [self addSubview:self.messageBody];
    
    self.autoresizesSubviews = YES;
    self.messageRightHeader.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.messageLeftHeader.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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

- (id) initWithProperties:(VKBubbleViewProperties *) properties{
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

















