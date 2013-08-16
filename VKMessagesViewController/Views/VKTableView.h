//
//  VKTableView.h
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VKTableView : UITableView
- (void) scrollToBottom;
- (void) scrollToBottomAnimated:(BOOL) animated;
@end
