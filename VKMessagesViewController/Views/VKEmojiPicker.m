//
//  UDEmojiPicker.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKEmojiPicker.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
    #define DEFAULT_EMOJI_LIST @"😄,😃,😀,😊,☺,😉,😍,😘,😚,😗,😙,😜,😝,😛,😳,😁,😔,😌,😒,😞,😣,😢,😂,😭,😪,😥,😰,😅,😓,😩,😫,😨,😱,😠,😡,😤,😖,😆,😋,😷,😎,😴,😵,😲,😟,😦,😧,😈,👿,😮,😬,😐,😕,😯,😶,😇,😏,😑"
#elif __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_1
    #define DEFAULT_EMOJI_LIST @"😄,😃,😊,☺,😍,😘,😚,😜,😝,😳,😁,😔,😌,😒,😞,😣,😢,😂,😭,😪,😥,😰,😅,😓,😩,😫,😨,😱,😠,😡,😤,😖,😆,😋,😷,😎,😵,😲,😈,👿,😐,😶,😇,😏"
#endif


static CGFloat kEmojButtonCellSize = 44;
static CGFloat kEmojiButtonSize = 44;
static CGFloat kEmojiButtonFontSize = 35;
static CGFloat kDefaultPicketSize = 100;

@interface VKEmojiPicker()
@property (strong,nonatomic) NSArray *emojiButtons;
@property (readwrite,nonatomic) UIButton *delButton;
@property (readwrite,nonatomic) UIScrollView *scrollView;
@property (readwrite,nonatomic) UIPageControl *pageControl;
@property (readwrite,nonatomic) UIImageView *background;
@property (nonatomic) UIEdgeInsets horizontalEgdeInsets;
@property (nonatomic) UIEdgeInsets verticalEgdeInsets;
@end

@implementation VKEmojiPicker
@synthesize emojiList = _emojiList;
@synthesize delButton = _delButton;
@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize background = _background;

#pragma mark - Publick properties

- (NSArray *) emojiList{
    if (!_emojiList) {
        _emojiList = [DEFAULT_EMOJI_LIST componentsSeparatedByString:@","];
    }
    return _emojiList;
}

- (void) setEmojiList:(NSArray *)emojiList{
    if (_emojiList != emojiList) {
        _emojiList = emojiList;
        [self updateButtons];
    }
}

- (void) updateButtons{
    for (UIButton *emojiButton in _emojiButtons) {
        [emojiButton removeFromSuperview];
    }
    
    NSMutableArray *mutableEmojiButtons = [NSMutableArray array];
    UIButton *emojiButton = nil;
    for (NSString *emojiSynbol in self.emojiList){
        emojiButton = [self buttonWithEmoji:emojiSynbol];
        [mutableEmojiButtons addObject:emojiButton];
        [self.scrollView addSubview:emojiButton];
    }
    _emojiButtons = [mutableEmojiButtons copy];
    [self applyPickerStyle];
}

- (UIButton *) delButton{
    if (!_delButton) {
        _delButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _delButton.frame = CGRectMake(self.frame.size.width - 44,
                                      0,
                                      44,
                                      34);
        [_delButton addTarget:self
                       action:@selector(delButtonPressed)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_delButton];
    }
    return _delButton;
}

- (UIScrollView *) scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIPageControl *) pageControl{
    if (!_pageControl) {
        _pageControl =  [[UIPageControl alloc] init];
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (void) setStyle:(VKEmojiPickerStyle)style{
    if (_style != style) {
        _style = style;
        [self applyPickerStyle];
    }
}

- (void) setEdgeInsets:(UIEdgeInsets) insets ForStyle:(VKEmojiPickerStyle) style{
    switch (style) {
        case VKEmojiPickerStyleHorizontal:
            _horizontalEgdeInsets = insets;
            [self applyPickerStyle];
            break;
            
        case VKEmojiPickerStyleVertical:
            _verticalEgdeInsets = insets;
            [self applyPickerStyle];
            break;
            
        default:
            break;
    }
}

#pragma mark - Private properties

- (UIImage *) backgroundImage{
    return self.background.image;
}

- (void) setBackgroundImage:(UIImage *)backgroundImage{
    self.background.image = backgroundImage;
}

- (UIImageView *) background{
    if (!_background) {
        _background = [[UIImageView alloc] init];
        _background.frame = self.bounds;
        _background.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_background];
        [self sendSubviewToBack:_background];
    }
    return _background;
}

- (NSArray *) emojiButtons{
    if (!_emojiButtons) {
        [self updateButtons];
    }
    return _emojiButtons;
}

#pragma mark - View methods

- (void) setFrame:(CGRect)frame{
    BOOL needLayout = !CGSizeEqualToSize(self.frame.size, frame.size);
    [super setFrame:frame];
    if (needLayout) {
        if (!_background) {
            [self background];
        }
        [self applyPickerStyle];
    }
}

- (void) setBounds:(CGRect)bounds {
    BOOL needLayout = !CGSizeEqualToSize(self.bounds.size, bounds.size);
    [super setBounds:bounds];
    if (needLayout) {
        if (!_background) {
            [self background];
        }
        [self applyPickerStyle];
    }
}

#pragma mark - Private methods

- (UIButton *) buttonWithEmoji:(NSString *) emoji{
    UIButton *emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    emojiButton.frame = CGRectMake(0, 0, kEmojiButtonSize, kEmojiButtonSize);
    [emojiButton.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:kEmojiButtonFontSize]];
    [emojiButton setTitle:emoji forState:UIControlStateNormal];
    [emojiButton addTarget:self action:@selector(emojiButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return emojiButton;
}

- (void) applyPickerStyle{
    switch (self.style) {
        case VKEmojiPickerStyleHorizontal:
            [self controlsLayoutHorizontal];
            [self buttonsLayoutHorizontal];
            break;
            
        default:
        case VKEmojiPickerStyleVertical:
            [self controlsLayoutVertical];
            [self buttonsLayoutVertical];
            break;
    }
}

#pragma mark - Buttons methods

- (void) emojiButtonPressed:(UIButton *) button{
    if ([self.delegate respondsToSelector:@selector(emojiPicker:SymbolPicked:)]) {
        [self.delegate emojiPicker:self SymbolPicked:button.titleLabel.text];
    }
}

- (void) delButtonPressed{
    if ([self.delegate respondsToSelector:@selector(emojiPickerDelButtonPressed:)]) {
        [self.delegate emojiPickerDelButtonPressed:self];
    }
}

#pragma mark - Layout mrthods

- (void) controlsLayoutHorizontal{
    CGRect scrollFrame = self.bounds;
    scrollFrame.origin.x += _horizontalEgdeInsets.left;
    scrollFrame.origin.y += _horizontalEgdeInsets.top;
    scrollFrame.size.width -= _horizontalEgdeInsets.right + _horizontalEgdeInsets.left;
    scrollFrame.size.height -= self.delButton.bounds.size.height + _horizontalEgdeInsets.bottom + _horizontalEgdeInsets.top;
    self.scrollView.frame = scrollFrame;
    self.pageControl.transform = CGAffineTransformMakeRotation(0);
    self.delButton.center = CGPointMake(self.bounds.size.width - self.delButton.bounds.size.width/2 - _horizontalEgdeInsets.right,
                                        self.bounds.size.height - self.delButton.bounds.size.height/2 - _horizontalEgdeInsets.bottom);
    self.delButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin;
    self.pageControl.center = CGPointMake(self.frame.size.width/2,
                                          self.delButton.center.y);
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
}

- (void) buttonsLayoutHorizontal{
    if (!_scrollView) {
        [self controlsLayoutHorizontal];
    }
    int xCount = (int) self.scrollView.frame.size.width/kEmojButtonCellSize;
    int yCount = (int) self.scrollView.frame.size.height/kEmojButtonCellSize;
    CGFloat x;
    CGFloat y;
    NSUInteger row = 0;
    NSUInteger column = 0;
    UIButton *button = nil;
    for (int i=0; i<[self.emojiButtons count]; i++) {
        button = [self.emojiButtons objectAtIndex:i];
        column = i / yCount;
        if (column > 0) {
            row = i % (column * yCount);
        }
        else{
            row = i;
        }
        
        x = self.scrollView.frame.size.width / xCount * ((double) column + 0.5);
        y = self.scrollView.frame.size.height / yCount * ((double) row + 0.5);
        
        button.center = CGPointMake(x, y);
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width/xCount*(column+1),
                                             self.scrollView.frame.size.height);
    
    self.pageControl.numberOfPages = (int)(self.scrollView.contentSize.width / self.scrollView.frame.size.width + 0.5);
}

- (void) controlsLayoutVertical{
    CGRect scrollFrame = self.bounds;
    scrollFrame.origin.x += _verticalEgdeInsets.left;
    scrollFrame.origin.y += _verticalEgdeInsets.top;
    scrollFrame.size.width -= kEmojiButtonSize + _verticalEgdeInsets.right - _verticalEgdeInsets.left;
    scrollFrame.size.height -= _verticalEgdeInsets.bottom + _verticalEgdeInsets.top;
    self.scrollView.frame = scrollFrame;
    self.pageControl.transform = CGAffineTransformMakeRotation(M_PI/2);
    self.delButton.center = CGPointMake(self.frame.size.width - kEmojiButtonSize/2,
                                        self.delButton.frame.size.height/2);
    self.delButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin;
    self.pageControl.center = CGPointMake(self.frame.size.width - kEmojiButtonSize/2,
                                          self.frame.size.height/2);
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
}

- (void) buttonsLayoutVertical{
    if (!_scrollView) {
        [self controlsLayoutVertical];
    }
    
    int xCount = (int) self.scrollView.frame.size.width/kEmojButtonCellSize;
    int yCount = (int) self.scrollView.frame.size.height/kEmojButtonCellSize;
    CGFloat x;
    CGFloat y;
    NSUInteger row = 0;
    NSUInteger column = 0;
    UIButton *button = nil;
    for (int i=0; i<[self.emojiButtons count]; i++) {
        button = [self.emojiButtons objectAtIndex:i];
        row = i / xCount;
        if (row > 0) {
            column = i % (row * xCount);
        }
        else{
            column = i;
        }
        
        x = self.scrollView.frame.size.width / xCount * ((double) column + 0.5);
        y = self.scrollView.frame.size.height / yCount * ((double) row + 0.5);
        
        button.center = CGPointMake(x, y);
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,
                                            self.scrollView.frame.size.height/yCount*(row+1));
    
    self.pageControl.numberOfPages = (int)(self.scrollView.contentSize.height / self.scrollView.frame.size.height + 0.5);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    switch (self.style) {
        case VKEmojiPickerStyleHorizontal:
            self.pageControl.currentPage = self.scrollView.contentOffset.x / self.scrollView.frame.size.width +0.5;
            break;
            
        case VKEmojiPickerStyleVertical:
            self.pageControl.currentPage = self.scrollView.contentOffset.y / self.scrollView.frame.size.height +0.5;
            break;
        default:
            break;
    }
}

#pragma mark - Init methods

- (id) init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kDefaultPicketSize, kDefaultPicketSize);
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self background];
        [self applyPickerStyle];
    }
    return self;
}

@end














