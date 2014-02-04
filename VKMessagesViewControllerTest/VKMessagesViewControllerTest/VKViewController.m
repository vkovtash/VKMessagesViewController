//
//  VKViewController.m
//  VKMessagesViewControllerTest
//
//  Created by kovtash on 16.08.13.
//  Copyright (c) 2013 kovtash.com. All rights reserved.
//

#import "VKViewController.h"
#import "VKInboundTextBubbleCell.h"
#import "VKOutboundTextBubbleCell.h"
#import "VKInboundImageBubbleCell.h"
#import "VKOutboundImageBubbleCell.h"

@interface VKViewController()
@property (strong, nonatomic) NSMutableArray *messageStorage;
@end

@implementation VKViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    self.alternativeInputView = [self newEmojiPicker];
    
    [self.messageStorage addObjectsFromArray:@[
                                               @{@"type":@"text",
                                                 @"text":@"1 Lorem ipsum",
                                                 @"date":[NSDate date]},
                                               
                                               @{@"type":@"text",
                                                 @"text":@"2 Lorem ipsum dolor sit amet",
                                                 @"date":[NSDate date]},
                                               
                                               @{@"type":@"text",
                                                 @"text":@"3 Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                                                 @"date":[NSDate date]},
                                               
                                               @{@"type":@"text",
                                                 @"text":@"4 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam cursus diam diam",
                                                 @"date":[NSDate date]},
                                               
                                               @{@"type":@"text",
                                                 @"text":@"5 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam cursus diam diam, vitae gravida urna blandit non.",
                                                 @"date":[NSDate date]},
                                               
                                               @{@"type":@"image",
                                                 @"image_name":@"image01.jpg",
                                                 @"date":[NSDate date]},
                                               
                                               @{@"type":@"image",
                                                 @"image_name":@"image02.png",
                                                 @"date":[NSDate date]},
                                               
                                               @{@"type":@"image",
                                                 @"image_name":@"image03.jpg",
                                                 @"date":[NSDate date]},
                                               
                                               @{@"type":@"image",
                                                 @"image_name":@"no_image.jpg",
                                                 @"date":[NSDate date]}
                                               ]];
    
    [self.tableView registerClass:[VKOutboundTextBubbleCell class]
           forCellReuseIdentifier:VKInboundTextBubbleCellReuseIdentifier];
    [self.tableView registerClass:[VKInboundTextBubbleCell class]
           forCellReuseIdentifier:VKOutboundTextBubbleCellReuseIdentifier];
    [self.tableView registerClass:[VKInboundImageBubbleCell class]
           forCellReuseIdentifier:VKInboundImageBubbleCellReuseIdentifier];
    [self.tableView registerClass:[VKOutboundImageBubbleCell class]
           forCellReuseIdentifier:VKOutboundImageBubbleCellReuseIdentifier];
}

- (NSMutableArray *) messageStorage{
    if (!_messageStorage) {
        _messageStorage = [NSMutableArray array];
    }
    return _messageStorage;
}

#pragma mark - UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *message = self.messageStorage[indexPath.row];
    VKDefaultBubbleCell *messageCell = nil;
    
    if ([message[@"type"] isEqualToString:@"text"]) {
        if (indexPath.row%2) {
            messageCell = [tableView dequeueReusableCellWithIdentifier:VKInboundTextBubbleCellReuseIdentifier];
        }
        else{
            messageCell = [tableView dequeueReusableCellWithIdentifier:VKOutboundTextBubbleCellReuseIdentifier];
        }
        
         [(VKTextBubbleView *)messageCell.bubbleView messageBody].text = message[@"text"];
    }
    else if ([message[@"type"] isEqualToString:@"image"]) {
        if (indexPath.row%2) {
            messageCell = [tableView dequeueReusableCellWithIdentifier:VKInboundImageBubbleCellReuseIdentifier];
        }
        else{
            messageCell = [tableView dequeueReusableCellWithIdentifier:VKOutboundImageBubbleCellReuseIdentifier];
        }
        VKImageBubbleView *imageBubble = (VKImageBubbleView *)messageCell.bubbleView;
        imageBubble.messageBody.image = [UIImage imageNamed:message[@"image_name"]];
        CGSize imageSize = CGSizeMake(500, 400);
        if (imageBubble.messageBody.image) {
            imageSize = imageBubble.messageBody.image.size;
        }
        imageBubble.placeholderSize = imageSize;
    }
    
    if (!indexPath.row%2) {
        switch (indexPath.row%3) {
            case 0:
                messageCell.messageState = @"Sending...";
                break;
                
            case 1:
                messageCell.messageState = @"Sent";
                break;
                
            case 2:
                messageCell.messageState = @"Delivered";
                break;
                
            default:
                messageCell.messageState = nil;
                break;
        }
    }
    
    messageCell.messageDate = message[@"date"];
    return messageCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.messageStorage count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *message = self.messageStorage[indexPath.row];
    if ([message[@"type"] isEqualToString:@"text"]) {
        if (indexPath.row%2) {
            return [VKInboundTextBubbleCell heightForText:message[@"text"]
                                                    Widht:self.view.bounds.size.width];
        }
        else {
            return [VKOutboundTextBubbleCell heightForText:message[@"text"]
                                                     Widht:self.view.bounds.size.width];
        }
    }
    else if ([message[@"type"] isEqualToString:@"image"]) {
        UIImage *image = [UIImage imageNamed:message[@"image_name"]];
        CGSize imageSize = CGSizeMake(500, 400);
        if (image) {
            imageSize = image.size;
        }
        if (indexPath.row%2) {
            return [VKInboundImageBubbleCell heightForImageSize:imageSize
                                                          widht:self.view.bounds.size.width];
        }
        else {
            return [VKOutboundImageBubbleCell heightForImageSize:imageSize
                                                           widht:self.view.bounds.size.width];
        }
    }
    
    return 0;
}

- (BOOL) shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL) canPerformAction:(SEL)action
        forRowAtIndexPath:(NSIndexPath *)indexPath
               withSender:(id)sender {
    NSString *selectorName = NSStringFromSelector(action);
    if ([selectorName isEqualToString:@"copy:"] && [self.messageStorage[indexPath.row][@"type"] isEqualToString:@"text"]) {
        return YES;
    }
    else if ([selectorName isEqualToString:@"delete:"]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void) performAction:(SEL)action
     forRowAtIndexPath:(NSIndexPath *)indexPath
            withSender:(id)sender {
    NSString *selectorName = NSStringFromSelector(action);
    if ([selectorName isEqualToString:@"copy:"] && [self.messageStorage[indexPath.row][@"type"] isEqualToString:@"text"]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.messageStorage[indexPath.row][@"text"];
    }
    else if ([selectorName isEqualToString:@"delete:"]) {
        [self.messageStorage removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

#pragma mark - UIInputToolbarDelegate

- (void) inputButtonPressed:(UIInputToolbar *)toolbar {
    [self.messageStorage addObject:@{@"text":self.messageToolbar.textView.text,
                                     @"date":[NSDate date],
                                     @"type":@"text"}];
    [self.tableView reloadData];
    [self scrollTableViewToBottomAnimated:YES];
    [super inputButtonPressed:toolbar];
}

@end
