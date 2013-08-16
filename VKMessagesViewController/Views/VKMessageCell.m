//
//  VKMessageCell.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "VKMessageCell.h"

@interface VKMessageCell()
@property (nonatomic,strong) UIImage *normalBackgroundImgage;
@property (nonatomic,strong) UIImage *selectedBackgroundImgage;
@end

@implementation VKMessageCell

#pragma mark - Publick properties

- (NSString *) messageText{
    return self.bubbleView.messageBody.text;
}

- (void) setMessageText:(NSString *)messageText{
    self.bubbleView.messageBody.text = messageText;
    [self applyLayout];
}

- (void) setCellStyle:(VKMessageCellStyle)cellStyle{
    _cellStyle = cellStyle;
    switch (cellStyle) {
        case VKMessageCellStyleNormal:
            self.bubbleView.backgroundImage = self.normalBackgroundImgage;
            break;
            
        case VKMessageCellStyleSelected:
            self.bubbleView.backgroundImage = self.selectedBackgroundImgage;
            break;
    }
    [self applyLayout];
}

- (void) setMessageDate:(NSDate *)messageDate{
    if (_messageDate != messageDate) {
        _messageDate = messageDate;
        self.bubbleView.messageRightHeader.text = [self.dateFormatter stringFromDate:_messageDate];
    }
}

- (NSString *) messageLeftHeader{
    return self.bubbleView.messageLeftHeader.text;
}

- (void) setMessageLeftHeader:(NSString *)messageLeftHeader{
    self.bubbleView.messageLeftHeader.text = messageLeftHeader;
}

- (void) setBubbleAlign:(VKBubbleAlign)bubbleAlign{
    _bubbleAlign = bubbleAlign;
    [self applyLayout];
}

#pragma mark - Publick methods

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected) {
        self.cellStyle = VKMessageCellStyleSelected;
    }
    else{
        self.cellStyle = VKMessageCellStyleNormal;
    }
}

- (void) setBackgroundImage:(UIImage *) image forStyle:(VKMessageCellStyle) style{
    switch (style) {
        case VKMessageCellStyleNormal:
            self.normalBackgroundImgage = image;
            break;
            
        case VKMessageCellStyleSelected:
            self.selectedBackgroundImgage = image;
            break;
    }
    
    self.cellStyle = self.cellStyle;
}

#pragma mark - Class methods

+ (CGFloat) bubbleViewWidthMultiplier{
    return 0.9;
}

+ (UIEdgeInsets) edgeInsets{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

+ (CGFloat) estimatedHeightForText:(NSString *) text Widht:(CGFloat) width BubbleProperties:(VKBubbleViewProperties *) properties{
    UIEdgeInsets insets = [[self class] edgeInsets];
    return insets.top + insets.bottom + [properties estimatedSizeForText:text
                                                                   Widht:width*[[self class] bubbleViewWidthMultiplier]-insets.right-insets.left].height;
}

#pragma - mark Init

- (void) postInit{
    [self addSubview:self.bubbleView];
    self.autoresizesSubviews = YES;
}

- (void) setFrame:(CGRect)frame{
    BOOL layoutNeeded = !CGSizeEqualToSize(self.frame.size, frame.size);
    [super setFrame:frame];
    if (layoutNeeded) {
        [self applyLayout];
    }
}

- (void) applyLayout{
    UIEdgeInsets insets = [[self class] edgeInsets];
    CGFloat estimatedWidth = [self.bubbleView.properties estimatedWidthForText:self.bubbleView.messageBody.text
                                                                         Width:self.frame.size.width*[[self class] bubbleViewWidthMultiplier]-insets.right-insets.left];
    
    switch (self.bubbleAlign) {
        case VKBubbleAlignRight:
            self.bubbleView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
            self.bubbleView.frame = CGRectMake(self.frame.size.width - estimatedWidth - insets.right,
                                               insets.top,
                                               estimatedWidth,
                                               self.frame.size.height - insets.top - insets.bottom);
            break;
        
        case VKBubbleAlignLeft:
        default:
            self.bubbleView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
            self.bubbleView.frame = CGRectMake(insets.left,
                                               insets.top,
                                               estimatedWidth,
                                               self.frame.size.height - insets.top - insets.bottom);
            break;
    }
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self postInit];
    }
    return self;
}

- (id)  init{
    self = [super init];
    if (self) {
        [self postInit];
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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self postInit];
    }
    return self;
}

- (id)initWithBubbleView:(VKBubbleView *)bubbleView reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bubbleView = bubbleView;
        [self postInit];
    }
    return self;
}

@end
