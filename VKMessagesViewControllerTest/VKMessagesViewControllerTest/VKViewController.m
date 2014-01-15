//
//  VKViewController.m
//  VKMessagesViewControllerTest
//
//  Created by kovtash on 16.08.13.
//  Copyright (c) 2013 kovtash.com. All rights reserved.
//

#import "VKViewController.h"
#import "VKTextBubbleView.h"
#import "VKDefaultBubbleCell.h"
#import "VKDefaultBubbleCell+VKTextBubbleCell.h"
#import "VKDefaultBubbleCell+VKImageBubbleCell.h"

@interface VKViewController()
@property (strong, nonatomic) NSMutableArray *messageStorage;
@end

@implementation VKViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    self.alternativeInputView = [self newEmojiPicker];
    
    [self.messageStorage addObjectsFromArray:@[
                                               @{@"type":@"text",
                                                 @"text":@"1 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam cursus diam diam, vitae gravida urna blandit non.",
                                                 @"date":[NSDate date]},
                                               
                                               @{@"type":@"text",
                                                 @"text":@"2 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam cursus diam diam, vitae gravida urna blandit non.",
                                                 @"date":[NSDate date]},
                                               
                                               @{@"type":@"text",
                                                 @"text":@"3 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam cursus diam diam, vitae gravida urna blandit non.",
                                                 @"date":[NSDate date]},
                                               
                                               @{@"type":@"text",
                                                 @"text":@"4 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam cursus diam diam, vitae gravida urna blandit non.",
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
                                                 @"date":[NSDate date]}
                                               ]];
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
            messageCell = [VKDefaultBubbleCell getInboundTextMessageCell:tableView];
        }
        else{
            messageCell = [VKDefaultBubbleCell getOutboundTextMessageCell:tableView];
        }
        
         [(VKTextBubbleView *)messageCell.bubbleView messageBody].text = message[@"text"];
    }
    else if ([message[@"type"] isEqualToString:@"image"]) {
        if (indexPath.row%2) {
            messageCell = [VKDefaultBubbleCell getInboundImageMessageCell:tableView];
        }
        else{
            messageCell = [VKDefaultBubbleCell getOutboundImageMessageCell:tableView];
        }
        
        [(VKImageBubbleView *)messageCell.bubbleView messageBody].image = [UIImage imageNamed:message[@"image_name"]];
    }
    
    if (!indexPath.row%2) {
        switch (indexPath.row%3) {
            case 0:
                messageCell.messageState = @"Sending";
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
            return [VKDefaultBubbleCell heightForInboundTextBubbleCell:message[@"text"]
                                                                 Widht:self.view.bounds.size.width];
        }
        else {
            return [VKDefaultBubbleCell heightForOutboundTextBubbleCell:message[@"text"]
                                                                  Widht:self.view.bounds.size.width];
        }
    }
    else if ([message[@"type"] isEqualToString:@"image"]) {
        if (indexPath.row%2) {
            return [VKDefaultBubbleCell heightForInboundImageBubbleCell:[UIImage imageNamed:message[@"image_name"]]
                                                                  Widht:self.view.bounds.size.width];
        }
        else {
            return [VKDefaultBubbleCell heightForOutboundImageBubbleCell:[UIImage imageNamed:message[@"image_name"]]
                                                                   Widht:self.view.bounds.size.width];
        }
    }
    
    return 0;
}

#pragma mark VKMessagesViewController methods

- (void) inputButtonPressed{
    [self.messageStorage addObject:@{@"text":self.messageToolbar.textView.text,
                                     @"date":[NSDate date]}];
    [self.tableView reloadData];
}

@end
