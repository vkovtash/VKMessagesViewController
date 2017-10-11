//
//  By VJK on Stack Overflow: http://stackoverflow.com/a/10358135/790036
//

#import "UIResponder+ZIMFirstResponder.h"
#import <objc/runtime.h>

static void *kFirstResponderKey = &kFirstResponderKey;

@implementation UIResponder (ZIMFirstResponder)

- (__kindof UIResponder*)zim_currentFirstResponder {
  [UIApplication.sharedApplication sendAction:@selector(zim_findFirstResponder:) to:nil from:self forEvent:nil];
  id obj = objc_getAssociatedObject(self, kFirstResponderKey);
  objc_setAssociatedObject(self, kFirstResponderKey, nil, OBJC_ASSOCIATION_ASSIGN);
  return obj;
}

- (void)setZim_CurrentFirstResponder:(__kindof UIResponder*)responder {
    objc_setAssociatedObject(self, kFirstResponderKey, responder, OBJC_ASSOCIATION_ASSIGN);
}

- (void)zim_findFirstResponder:(id)sender {
    [sender setZim_CurrentFirstResponder:self];
}

@end
