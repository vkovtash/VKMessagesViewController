//
//  NSString+deletingLastSymbol.m
//  VKMessagesViewController
//
//  Created by Vlad Kovtash on 11.03.13.
//  Copyright (c) 2013 Vlad Kovtash. All rights reserved.
//

#import "NSString+deletingLastSymbol.h"

@implementation NSString (removeLastSymbol)
-(NSString *) stringByDeletingLastSymbol;{
    if (self.length > 0) {
        NSRange rangeOfLastChar = [self rangeOfComposedCharacterSequenceAtIndex: [self length] - 1];
        return [self substringToIndex: rangeOfLastChar.location];
    }
    else{
        return self;
    }
}
@end
