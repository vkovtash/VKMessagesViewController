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
#import "VKBaseBubbleCell+VKTextBubbleCell.h"

@interface VKViewController()
@property (strong, nonatomic) NSMutableArray *messageStorage;
@end

@implementation VKViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    self.alternativeInputView = [self newEmojiPicker];
    
    [self.messageStorage addObjectsFromArray:@[
                                               @{@"text":@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam cursus diam diam, vitae gravida urna blandit non.",
                                                 @"date":[NSDate date]},
                                               @{@"text":@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam cursus diam diam, vitae gravida urna blandit non.",
                                                 @"date":[NSDate date]},
                                               @{@"text":@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam cursus diam diam, vitae gravida urna blandit non.",
                                                 @"date":[NSDate date]},
                                               @{@"text":@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam cursus diam diam, vitae gravida urna blandit non.",
                                                 @"date":[NSDate date]},
                                               @{@"text":@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam cursus diam diam, vitae gravida urna blandit non.",
                                                 @"date":[NSDate date]}]];
}

- (NSMutableArray *) messageStorage{
    if (!_messageStorage) {
        _messageStorage = [NSMutableArray array];
    }
    return _messageStorage;
}

#pragma mark - UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *message = self.messageStorage[indexPath.row];
    VKDefaultBubbleCell *messageCell = nil;
    
    if (indexPath.row%2) {
        messageCell = (VKDefaultBubbleCell*)[self getInboundTextMessageCell:tableView];
    }
    else{
        messageCell = (VKDefaultBubbleCell*)[self getOutboundTextMessageCell:tableView];
        
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
    
    [(VKTextBubbleView *)messageCell.bubbleView messageBody].text = message[@"text"];
    messageCell.messageDate = message[@"date"];
    return messageCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.messageStorage count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *message = self.messageStorage[indexPath.row];
    if (indexPath.row%2) {
        return [VKDefaultBubbleCell heightForInboundTextBubbleCell:message[@"text"] Widht:self.view.bounds.size.width];
    }
    else {
        return [VKDefaultBubbleCell heightForOutboundTextBubbleCell:message[@"text"] Widht:self.view.bounds.size.width];
    }
}

#pragma mark VKMessagesViewController methods

- (void) inputButtonPressed{
    [self.messageStorage addObject:@{@"text":self.messageToolbar.textView.text,
                                     @"date":[NSDate date]}];
    [self.tableView reloadData];
}

@end
