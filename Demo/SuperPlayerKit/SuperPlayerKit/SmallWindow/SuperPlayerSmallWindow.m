// Copyright (c) 2024 Tencent. All rights reserved.
//

#import "SuperPlayerSmallWindow.h"

@implementation SuperPlayerSmallWindow

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(self.rootView.bounds, [self.rootView convertPoint:point fromView:self])) {
        return [super pointInside:point withEvent:event];
    }

    return NO;
}

@end
