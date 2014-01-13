//
//  VKViewController.m
//  VKMessagesViewControllerTest
//
//  Created by kovtash on 16.08.13.
//  Copyright (c) 2013 kovtash.com. All rights reserved.
//

#import "VKViewController.h"
#import "VKTextBubbleView.h"
#import "VKBaseBubbleCell.h"
#import "VKBubbleCell+VKTextBubbleEstimate.h"

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
    VKBaseBubbleCell *messageCell = nil;
    
    if (indexPath.row%2) {
        messageCell = (VKBaseBubbleCell*)[self getInboundTextMessageCell:tableView];
    }
    else{
        messageCell = (VKBaseBubbleCell*)[self getOutboundTextMessageCell:tableView];
        
        switch (indexPath.row%3) {
            case 0:
                messageCell.messageLeftHeader = @"Sending";
                break;
                
            case 1:
                messageCell.messageLeftHeader = @"Sent";
                break;
                
            case 2:
                messageCell.messageLeftHeader = @"Delivered";
                break;
                
            default:
                messageCell.messageLeftHeader = nil;
                break;
        }
    }
    
    [(VKTextBubbleView *)messageCell.bubbleView textBody].text = message[@"text"];
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
        return [VKBubbleCell estimatedHeightForText:message[@"text"]
                                               Widht:self.view.bounds.size.width
                                    BubbleProperties:self.inboundBubbleViewProperties];
    }
    else {
        return [VKBubbleCell estimatedHeightForText:message[@"text"]
                                               Widht:self.view.bounds.size.width
                                    BubbleProperties:self.outboundBubbleViewProperties];
    }
}

#pragma mark VKMessagesViewController methods

- (void) inputButtonPressed{
    [self.messageStorage addObject:@{@"text":self.messageToolbar.textView.text,
                                     @"date":[NSDate date]}];
    [self.tableView reloadData];
}

@end
