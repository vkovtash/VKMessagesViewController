//
//  VKBobbleView.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKBubbleView.h"
#import "UIActionSheet+VKBlocks.h"


@implementation VKBubbleImageBackground
@synthesize isSelected = _isSelected;

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

- (void)applyIsSelected {
    if (_isSelected && _selectedBackgroundImage) {
        self.image = self.selectedBackgroundImage;
    }
    else {
        self.image = self.normalBackgroundImage;
    }
}

@end


@interface VKBubblePathBackground()
@property (strong, nonatomic) CAShapeLayer *shape;
@end

@implementation VKBubblePathBackground
@synthesize isSelected = _isSelected;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupShape];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupShape];
    }
    return self;
}

- (void)setupShape {
    _shape = [CAShapeLayer layer];
    [self.layer addSublayer:_shape];
    [self setIsSelected:NO];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.shape.path =  self.pathBlock ? self.pathBlock(self.bounds) : nil;
}

- (void)setPathBlock:(CGPathRef (^)(CGRect))pathBlock {
    if (_pathBlock != pathBlock) {
        _pathBlock = pathBlock;
        self.shape.path = _pathBlock ? _pathBlock(self.bounds) : nil;
    }
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (_isSelected) {
        self.shape.fillColor =  self.selectedFillColor ? self.selectedFillColor.CGColor : self.fillColor.CGColor;
        self.shape.strokeColor = self.selectedBorderColor ? self.selectedBorderColor.CGColor : self.borderColor.CGColor;
    }
    else {
        self.shape.fillColor = self.fillColor.CGColor;
        self.shape.strokeColor = self.borderColor.CGColor;
    }
}

- (void)setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    if (self.isSelected) {
        self.shape.fillColor =  self.selectedFillColor ? self.selectedFillColor.CGColor : self.fillColor.CGColor;
    }
    else {
        self.shape.fillColor = self.fillColor.CGColor;
    }
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    if (self.isSelected) {
        self.shape.strokeColor = self.selectedBorderColor ? self.selectedBorderColor.CGColor : self.borderColor.CGColor;
    }
    else {
        self.shape.strokeColor = self.borderColor.CGColor;
    }
}

- (void)setSelectedFillColor:(UIColor *)selectedFillColor {
    _selectedFillColor = selectedFillColor;
    if (self.isSelected) {
        self.shape.fillColor =  self.selectedFillColor ? self.selectedFillColor.CGColor : self.fillColor.CGColor;
    }
}

- (void)setSelectedBorderColor:(UIColor *)selectedBorderColor {
    _selectedBorderColor = selectedBorderColor;
    if (self.isSelected) {
        self.shape.strokeColor = self.selectedBorderColor ? self.selectedBorderColor.CGColor : self.borderColor.CGColor;
    }
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.shape.lineWidth = borderWidth;
}

@end


@implementation VKBubbleView

#pragma mark - Public Properties

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

- (void)setBackground:(UIView<VKBubbleViewBackgroudProtocol> *)background {
    if (_background == background) {
        return;
    }
    
    [_background removeFromSuperview];
    _background = background;
    [self addSubview:_background];
    [self sendSubviewToBack:_background];
    _background.backgroundColor = self.backgroundColor;
    _background.frame = self.bounds;
    _background.isSelected = self.isSelected;
}

- (void)setClippingPathBlock:(VKPathBlock)clippingPathBlock {
    _clippingPathBlock = clippingPathBlock;
    [self applyClippingMask];
}

#pragma mark - Private methods

- (void)applyIsSelected {
    self.background.isSelected = self.isSelected;
}

- (void)applyClippingMask {
    if (self.clippingPathBlock) {
        CAShapeLayer *mask = self.layer.mask;
        if (!mask) {
            mask = [CAShapeLayer new];
        }
        mask.path = self.clippingPathBlock(self.bounds);
        self.layer.mask = mask;
    }
    else {
        self.layer.mask = nil;
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
    
    [self applyClippingMask];
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
        _properties = properties;
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
