//
//  UIView+FindAndResignFirstResponder.m
//  SFCMobile
//
//  Created by Jinsong Lu on 9/24/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "UIView+FindAndResignFirstResponder.h"

@implementation UIView (FindAndResignFirstResponder)
- (BOOL)findAndResignFirstResponder
{
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;
    }
    for (UIView *subView in self.subviews) {
        if ([subView findAndResignFirstResponder])
            return YES;
    }
    return NO;
}@end
