//
//  VKTextBubbleView.m
//  VKMessagesViewControllerTest
//
//  Created by Vlad Kovtash on 24/12/13.
//  Copyright (c) 2013 kovtash.com. All rights reserved.
//

#import "VKTextBubbleView.h"

static CGFloat const kViewMaxHeight = 9999;
static NSInteger const kTextPartsCount = 4;


static inline void higliteStringWith(NSMutableAttributedString *attributedString, NSArray<NSTextCheckingResult *> *matches, UIColor *color) {
    for (NSTextCheckingResult *match in matches) {
        for (NSUInteger i = 0; i < match.numberOfRanges; i++) {
            NSRange tokenRange = [match rangeAtIndex:i];
            [attributedString addAttributes:@{
                                              kTTTBackgroundCornerRadiusAttributeName: @2,
                                              kTTTBackgroundFillColorAttributeName: color
                                              }
                                      range:tokenRange];
        }
    }
}

#pragma mark - VKBubbleMention

@implementation VKBubbleMention
@synthesize hash = _hash;

- (instancetype)initWithRange:(NSRange)range url:(NSURL *)url {
    self = [super init];
    if (self) {
        _range = range;
        _url = url;
        _hash = url.hash ^ range.length ^ range.location;
    }
    return self;
}

+ (instancetype)withRange:(NSRange)range url:(NSURL *)url {
    return [[[self class] alloc] initWithRange:range url:url];
}

- (BOOL)isEqual:(VKBubbleMention *)object {
    return [object isKindOfClass:[self class]] &&
           NSEqualRanges(object.range, self.range) &&
           [self.url isEqual:object.url];
}

@end


#pragma mark - VKTextBubbleView

@interface VKTextBubbleView()
@property (strong, nonatomic) NSMutableSet<VKBubbleMention *> *mutableMentions;
@property (assign, nonatomic) BOOL needsApplyAttributes;
@property (strong, nonatomic) NSAttributedString *originalAttributedText;
@end

@implementation VKTextBubbleView
@synthesize messageBody = _messageBody;
@dynamic properties;

- (instancetype)initWithBubbleProperties:(VKTextBubbleViewProperties *)properties {
    self = [super initWithBubbleProperties:properties];
    return self;
}

- (TTTAttributedLabel *)messageBody {
    if (!_messageBody) {
        _messageBody = [[TTTAttributedLabel alloc] initWithFrame:self.bounds];
        _messageBody.enabledTextCheckingTypes = NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber;
        _messageBody.delegate = self;
        _messageBody.backgroundColor = [UIColor clearColor];
        _messageBody.lineBreakMode = self.properties.lineBreakMode;
        _messageBody.numberOfLines = 0;
        [self applyTextProperties];
    }
    return _messageBody;
}

- (NSArray<VKBubbleMention *> *)mentions {
    return self.mutableMentions.allObjects;
}

- (NSMutableSet<VKBubbleMention *> *)mutableMentions {
    if (_mutableMentions) {
        _mutableMentions = [NSMutableSet set];
    }
    return _mutableMentions;
}

- (NSString *)text {
    return self.messageBody.text;
}

- (void)setText:(NSString *)text {
    if ([self.messageBody.text isEqualToString:text]) {
        return;
    }

    [self clearNeedsApplyAttributes];
    _highligts = nil;
    _mutableMentions = nil;
    self.messageBody.text = text;
    _originalAttributedText = self.messageBody.attributedText;
}

- (NSAttributedString *)attributedText {
    return self.messageBody.attributedText;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    if ([_originalAttributedText isEqualToAttributedString:attributedText]) {
        return;
    }

    [self clearNeedsApplyAttributes];
    _highligts = nil;
    _mutableMentions = nil;
    _originalAttributedText = [attributedText copy];
    self.messageBody.text = attributedText;
}

- (void)setProperties:(VKBubbleViewProperties *)properties {
    [super setProperties:properties];
    [self applyTextProperties];
}

- (CGSize)sizeConstrainedToWidth:(CGFloat)width {
    return [[self class] sizeWithAttributedString:self.messageBody.attributedText
                                       Properties:self.properties
                               constrainedToWidth:width];
}

- (void)setHighligts:(NSArray<NSString *> *)highligts {
    if (_highligts != highligts) {
        _highligts = highligts;
        [self setNeedsApplyAttributes];
    }
}

- (void)addMention:(VKBubbleMention *)mention {
    if ([self.mutableMentions containsObject:mention]) {
        return;
    }

    [self.mutableMentions addObject:mention];
    [self.messageBody addLinkToURL:mention.url withRange:mention.range];
}

- (void)addMentionWithURL:(NSURL *)url range:(NSRange)range {
    [self addMention:[VKBubbleMention withRange:range url:url]];
}

#pragma mark - Private API

- (void)setNeedsApplyAttributes {
    if (!_needsApplyAttributes) {
        _needsApplyAttributes = YES;
        [self performSelector:@selector(applyAttributes) withObject:nil afterDelay:0.01];
    }
}

- (void)clearNeedsApplyAttributes {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(applyAttributes) object:nil];
    _needsApplyAttributes = NO;
}

- (void)applyTextProperties {
    if (self.properties.font) {
        _messageBody.font = self.properties.font;
    }

    if (self.properties.textColor) {
        _messageBody.textColor = self.properties.textColor;
    }
}

- (void)applyAttributes {
    [self clearNeedsApplyAttributes];

    NSAttributedString *originalString = self.originalAttributedText;
    NSArray<NSString *> *hihglights = self.highligts;

    if (originalString.length == 0) {
        return;
    }

    if (hihglights.count == 0) {
        self.messageBody.text = originalString;
        return;
    }

    UIColor *color = [self.tintColor colorWithAlphaComponent:0.5];
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        NSString *string = originalString.string;

        NSMutableArray <NSTextCheckingResult *> *matches = [NSMutableArray new];

        for (NSString *text in hihglights) {
            NSError *error = nil;
            NSRegularExpression *regex =
                [NSRegularExpression regularExpressionWithPattern:text
                                                          options:NSRegularExpressionCaseInsensitive|NSRegularExpressionUseUnicodeWordBoundaries
                                                            error:&error];

            if (!error) {
                [matches addObjectsFromArray:[regex matchesInString:string options:0 range:NSMakeRange(0, string.length)]];
            }
        }

        NSMutableAttributedString *higligtedString = [originalString mutableCopy];
        higliteStringWith(higligtedString, matches, color);

        dispatch_async(dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            TTTAttributedLabel *label = strongSelf.messageBody;

            if (![label.attributedText.string isEqualToString:string]) {
                return;
            }

            if ([label.attributedText isEqualToAttributedString:originalString]) {
                label.attributedText = higligtedString;
            }
            else {
                // Attributes seems to be changed by TTTAttributedLabel data detectors.
                // Applying highlights to original string and staring over data detectors
                label.text = higligtedString;
            }
        });
    });
}

#pragma mark - UIView methods

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copy:));
}

#pragma mark - class methods

+ (CGSize)sizeWithAttributedString:(NSAttributedString *)attributedString
                        Properties:(VKTextBubbleViewProperties *)properties
                constrainedToWidth:(CGFloat)width {
    CGSize bodySize = CGSizeZero;
    
    if (attributedString) {
        bodySize = [TTTAttributedLabel sizeThatFitsAttributedString:attributedString
                                                    withConstraints:CGSizeMake(width - properties.edgeInsets.left - properties.edgeInsets.right, kViewMaxHeight)
                                             limitedToNumberOfLines:0];
    }
    
    bodySize.width += (properties.edgeInsets.left + properties.edgeInsets.right);
    CGFloat partSize = ceilf((width+kTextPartsCount)/kTextPartsCount);
    bodySize.width = ceilf(bodySize.width/partSize) * partSize;
    if (bodySize.width > width) {
        bodySize.width = width;
    }
    if (bodySize.width < properties.minimumWidth) {
        bodySize.width = properties.minimumWidth;
    }
    bodySize.height += (properties.edgeInsets.top + properties.edgeInsets.bottom);
    
    if (bodySize.height < properties.minimumHeight) {
        bodySize.height = properties.minimumHeight;
    }
    return bodySize;
}

+ (CGSize)sizeWithText:(NSString *)text
            Properties:(VKTextBubbleViewProperties *)properties
    constrainedToWidth:(CGFloat)width {
    
    NSAttributedString *attributedString = nil;
    if (text) {
        attributedString = [[NSAttributedString alloc] initWithString:text
                                                           attributes:properties.textAttributes];
    }
    
    return [[self class] sizeWithAttributedString:attributedString
                                       Properties:properties
                               constrainedToWidth:width];
}

#pragma mark - UIResponderStandardEditActions

- (void)copy:(id)sender {
    [[UIPasteboard generalPasteboard] setString:self.messageBody.text];
}

@end
